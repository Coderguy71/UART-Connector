#!/usr/bin/env python3
"""
UART test harness for the Tang Nano 20K ALU project.

Two modes:
  1. Raw monitor  - type hex bytes, see everything that comes back
  2. Calc mode     - walk through opcode/A/B, send 3 bytes, read the result byte

Port defaults to /dev/tty.usbserial-xxxxxxxxxxx, override with --port.
TO FIND YOUR OWN USE THIS IN THE COMMAND TERMINAL
  FOR MAC:  ls /dev/tty.* 
"""

import argparse
import sys
import threading
import time

import serial

BAUD = 9600
OPCODES = {
    "add": 0b001,
    "sub": 0b010,
    "mul": 0b011,
    "shl": 0b100,
    "shr": 0b101,
}


def reader_thread(ser, stop_event):
    while not stop_event.is_set():
        n = ser.in_waiting
        if n:
            data = ser.read(n)
            for b in data:
                print(f"  <- 0x{b:02X}  ({b:#010b})  [{b}]")
        else:
            time.sleep(0.02)


def raw_monitor(ser):
    stop_event = threading.Event()
    t = threading.Thread(target=reader_thread, args=(ser, stop_event), daemon=True)
    t.start()

    print("Raw monitor. Enter hex bytes (e.g. '01' or '01 05 03'), 'q' to quit.")
    try:
        while True:
            line = input("-> ").strip()
            if line.lower() in ("q", "quit", "exit"):
                break
            if not line:
                continue
            try:
                tokens = line.split()
                out = bytes(int(tok, 16) for tok in tokens)
            except ValueError:
                print("  bad hex input, try again")
                continue
            ser.write(out)
            print(f"  -> sent {[f'0x{b:02X}' for b in out]}")
    finally:
        stop_event.set()
        t.join()


def calc_mode(ser):
    print("Calc mode. Sends opcode byte, then A byte, then B byte.")
    print(f"Opcodes: {', '.join(f'{k}={v:03b}' for k, v in OPCODES.items())}")
    while True:
        op_str = input("opcode (add/sub/mul/shl/shr, q to quit): ").strip().lower()
        if op_str in ("q", "quit", "exit"):
            break
        if op_str not in OPCODES:
            print("  unrecognized opcode")
            continue
        try:
            a = int(input("A (0-15): ").strip())
            b = int(input("B (0-15): ").strip())
        except ValueError:
            print("  bad number")
            continue
        if not (0 <= a <= 15 and 0 <= b <= 15):
            print("  A and B must be 0-15 (4 bits)")
            continue

        opcode = OPCODES[op_str]
        ser.reset_input_buffer()

        for label, byte_val in (("opcode", opcode), ("A", a), ("B", b)):
            ser.write(bytes([byte_val]))
            print(f"  -> {label}: 0x{byte_val:02X} ({byte_val:#06b})")
            time.sleep(0.05)  # let the FPGA finish RX + CommandParser before next byte

        result = ser.read(1)
        if result:
            val = result[0]
            print(f"  <- result: 0x{val:02X} = {val} decimal")
        else:
            print("  <- no response (timed out)")


def main():
    parser = argparse.ArgumentParser(description="UART test harness for ALU project")
    parser.add_argument(
        "--port",
        default="/dev/tty.usbserial-20250303171",
        help="Serial port device path",
    )
    parser.add_argument(
        "--mode",
        choices=["raw", "calc"],
        default="calc",
        help="raw = manual byte monitor, calc = guided opcode/A/B send",
    )
    parser.add_argument("--timeout", type=float, default=1.0, help="Read timeout (s)")
    args = parser.parse_args()

    try:
        ser = serial.Serial(
            port=args.port,
            baudrate=BAUD,
            bytesize=serial.EIGHTBITS,
            parity=serial.PARITY_NONE,
            stopbits=serial.STOPBITS_ONE,
            timeout=args.timeout,
        )
    except serial.SerialException as e:
        print(f"Could not open {args.port}: {e}")
        sys.exit(1)

    print(f"Opened {args.port} at {BAUD} baud, 8N1")
    try:
        if args.mode == "raw":
            raw_monitor(ser)
        else:
            calc_mode(ser)
    except KeyboardInterrupt:
        pass
    finally:
        ser.close()


if __name__ == "__main__":
    main()
