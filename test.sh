MACHINE_MODEL="[    0.000000] Machine model: Raspberry Pi 3 Model B Rev 2.1"
if grep -q "Raspberry Pi 3" <<< "$MACHINE_MODEL"; then
    echo "Yes"
    MACHINE_MODEL_FORMATTED="raspberrypi4"
fi