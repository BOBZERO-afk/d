import mss

with mss.mss() as sct:
    for i, monitor in enumerate(sct.monitors):
        screenshot = sct.grab(monitor)
        mss.tools.to_png(screenshot.rgb, screenshot.size, output=f'screenshot{i}.png')
