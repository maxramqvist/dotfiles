#!/usr/bin/env python
import subprocess
import sys
def r(cmd):
  proc = subprocess.run([cmd], shell=True, stdout=subprocess.PIPE)
  val = proc.stdout.decode('UTF-8').strip()
  return val

def getCurrentBrightnessPC():
    return float(r("brightnessctl get")) / float(r("brightnessctl max")) * 100

def dec():
    curr=getCurrentBrightnessPC()
    if(curr >= 10):
        r("brightnessctl s 10%-")
    if(curr < 10 ):
        r("brightnessctl s 1%-")

def inc():
    curr=getCurrentBrightnessPC()
    if(curr >= 10):
        r("brightnessctl s 10%+")
    if(curr < 10 ):
        r("brightnessctl s 1%+")

match sys.argv[1]:
    case "i":
        inc()
    case "d":
        dec()
