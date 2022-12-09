TARGET := alsa_vol_from_usb_hid
USBHID_DEVICE ?= 

CORE_DIR := src
CONFIG_DIR := config
SYSTEMD_CONFIG_DIR := $(CONFIG_DIR)/etc/systemd/system

SYSTEMD_CONFIG_FILE := $(TARGET).service

SYSTEM_SYSTEMD_CONFIG_DIR := ~/.config/systemd/user
INSTALL_DIR_BIN := ~/bin

install:
	mkdir -p $(INSTALL_DIR_BIN)
	cp $(CORE_DIR)/$(TARGET).sh $(INSTALL_DIR_BIN)/$(TARGET)
	chmod a+x $(INSTALL_DIR_BIN)/$(TARGET)
	mkdir -p $(SYSTEM_SYSTEMD_CONFIG_DIR)
	cp $(SYSTEMD_CONFIG_DIR)/$(SYSTEMD_CONFIG_FILE) $(SYSTEM_SYSTEMD_CONFIG_DIR)/
	sed -i 's|%TARGET%|$(INSTALL_DIR_BIN)/$(TARGET)|g' $(SYSTEM_SYSTEMD_CONFIG_DIR)/$(SYSTEMD_CONFIG_FILE)
	sed -i 's|%USBHID_DEVICE%|$(USBHID_DEVICE)|g' $(SYSTEM_SYSTEMD_CONFIG_DIR)/$(SYSTEMD_CONFIG_FILE)
	systemctl --user daemon-reload
	systemctl --user enable $(TARGET)

uninstall:
	systemctl --user stop $(TARGET) 2> /dev/null || true
	killall $(TARGET) 2> /dev/null || true
	systemctl --user disable $(TARGET) 2> /dev/null || true
	rm $(SYSTEM_SYSTEMD_CONFIG_DIR)/$(SYSTEMD_CONFIG_FILE) 2> /dev/null || true
	rm $(INSTALL_DIR_BIN)/$(TARGET) 2> /dev/null || true

start:
	systemctl --user start $(TARGET)

stop:
	systemctl --user stop $(TARGET)

