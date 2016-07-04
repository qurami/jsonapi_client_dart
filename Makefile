#NAME = $(notdir $(shell pwd))
#IMAGE = qurami/$(NAME)

DART_DIST = dartsdk-linux-x64-release.zip
DART= $(PWD)/dart-sdk/bin/dart
PUB= $(PWD)/dart-sdk/bin/pub

ifdef CIRCLE_BUILD_NUM
	VERSION = $(CIRCLE_BUILD_NUM)
else
	VERSION = local
endif

app:
	# Get the Dart SDK.
	curl http://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/$(DART_DIST) > $(DART_DIST)
	unzip $(DART_DIST) > /dev/null
	rm $(DART_DIST)

	# Display installed versions.
	$(DART) --version

	# Get our packages.
	$(PUB) get

	# Verify that the libraries are error free.
	$(PUB) global activate tuneup
	$(PUB) global run tuneup check

tests:
	$(PUB) run test -p chrome
