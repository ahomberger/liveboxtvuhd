FROM mcr.microsoft.com/devcontainers/python:1-3.12

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Uninstall pre-installed formatting and linting tools
# They would conflict with our pinned versions
RUN \
    pipx uninstall pydocstyle \
    && pipx uninstall pycodestyle \
    && pipx uninstall mypy \
    && pipx uninstall pylint

RUN \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    # Additional library needed by some tests and accordingly by VScode Tests Discovery
    bluez \
    ffmpeg \
    libudev-dev \
    libavformat-dev \
    libavcodec-dev \
    libavdevice-dev \
    libavutil-dev \
    libgammu-dev \
    libswscale-dev \
    libswresample-dev \
    libavfilter-dev \
    libpcap-dev \
    libturbojpeg0 \
    libyaml-dev \
    libxml2 \
    git \
    cmake \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src

# Setup hass-release
# RUN git clone --depth 1 https://github.com/home-assistant/hass-release \
#     && pip3 install -e hass-release/

RUN git clone --depth 1 https://github.com/home-assistant/core

WORKDIR /usr/src/core
RUN pip3 install wheel -r requirements_all.txt

# WORKDIR /workspaces

# Install Python dependencies from requirements
# COPY requirements_all.txt requirements.txt ./
# COPY homeassistant/package_constraints.txt homeassistant/package_constraints.txt
# RUN pip3 install wheel -r requirements_all.txt
# COPY requirements_test.txt requirements_test_pre_commit.txt ./
# RUN pip3 install -r requirements_test.txt
# RUN rm -rf requirements.txt requirements_test.txt requirements_test_pre_commit.txt homeassistant/

# RUN rm -rf requirements_all.txt requirements.txt homeassistant/

RUN pip3 install homeassistant
RUN pip3 install home-assistant-frontend

# Set the default shell to bash instead of sh
ENV SHELL /bin/bash
