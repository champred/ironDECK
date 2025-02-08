FROM eclipse-temurin:8-jre-noble

#Variables for installation
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true
ENV XKB_DEFAULT_RULES=base

#Install dependencies
RUN apt-get update && \
        apt-get install -y \
        unzip \
        gnupg \
        apt-transport-https \
        dbus-x11 \
        software-properties-common \
        libxv1 \
        libglu1-mesa \
        xauth \
        x11-utils \
        xorg \
        x11-xkb-utils \
        libgtk2.0-0 \
        lsb-release \
        libopenal1 \
        libsdl-image1.2 \
        libsdl-ttf2.0-0 \
        libsdl1.2debian \
        libsdl-sound1.2 \
        wget \
        curl \
        git \
        mono-complete \
        liblua5.4-dev \
        libopenal-dev \
        lua5.4 \
        mesa-utils \
        && rm -rf /var/lib/apt/lists/* && apt-get clean

# Install font
COPY ["Franklin Gothic Medium Regular.ttf", "/usr/local/share/fonts/"]
RUN fc-cache -f

# Download Bizhawk & Ironmon-Tracker & Randomizer
WORKDIR /opt/BizHawk
RUN curl -L https://github.com/TASEmulators/BizHawk/releases/download/2.10/BizHawk-2.10-linux-x64.tar.gz | tar xz
ADD https://github.com/besteon/Ironmon-Tracker.git Lua
RUN wget -O upr.zip https://github.com/Ajarmar/universal-pokemon-randomizer-zx/releases/download/v4.6.1/PokeRandoZX-v4_6_1.zip && \
    unzip upr.zip PokeRandoZX.jar -d Lua/Ironmon-Tracker && rm upr.zip
ENTRYPOINT /bin/bash EmuHawkMono.sh --lua=Lua/Ironmon-Tracker/Ironmon-Tracker.lua $ROM_FILE
