PLUGIN         := TapPanZeit
USER_PLUGINS   := $(HOME)/Library/Audio/Plug-Ins
SYSTEM_PLUGINS := /Library/Audio/Plug-Ins
INSTALLED      := VST3/$(PLUGIN).vst3 Components/$(PLUGIN).component
PKG_IDS        := us.steinkamp.TapPanZeit.vst3 us.steinkamp.TapPanZeit.au

.PHONY: clean

# Remove installed plug-ins from the user folder (manual copies) and the
# system folder (.pkg installer), and forget the installer receipts.
# Only asks for sudo when there is something system-wide to remove.
clean:
	rm -rf $(addprefix $(USER_PLUGINS)/,$(INSTALLED))
	@for f in $(addprefix $(SYSTEM_PLUGINS)/,$(INSTALLED)); do \
	  if [ -e "$$f" ]; then echo "sudo rm -rf $$f"; sudo rm -rf "$$f"; fi; \
	done
	@for id in $(PKG_IDS); do \
	  if pkgutil --pkg-info $$id >/dev/null 2>&1; then echo "sudo pkgutil --forget $$id"; sudo pkgutil --forget $$id >/dev/null; fi; \
	done
	-@killall -9 AudioComponentRegistrar 2>/dev/null
