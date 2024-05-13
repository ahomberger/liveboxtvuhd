# Automatically generated by hassfest.
#
# To update, run python3 -m script.hassfest -p docker
ARG BUILD_FROM
FROM ${BUILD_FROM}

# Synchronize with homeassistant/core.py:async_stop
ENV \
    S6_SERVICES_GRACETIME=240000 \
    UV_SYSTEM_PYTHON=true

ARG QEMU_CPU

# Install uv
RUN pip3 install uv==0.1.39

WORKDIR /usr/src

## Setup Home Assistant Core dependencies
COPY requirements.txt homeassistant/
COPY package_constraints.txt homeassistant/homeassistant/
RUN \
    uv pip install \
    --no-build \
    -r requirements.txt

# COPY requirements_all.txt home_assistant_frontend-* home_assistant_intents-* homeassistant/
COPY requirements_all.txt homeassistant/
RUN \
    uv pip install \
    --no-build \
    -r requirements_all.txt;


## Setup Home Assistant Core
# COPY . homeassistant/
RUN \
    uv pip install \
    -e ./homeassistant \
    && python3 -m compileall \
    homeassistant/homeassistant

# Home Assistant S6-Overlay
# COPY rootfs /

# WORKDIR /config
WORKDIR /workspaces