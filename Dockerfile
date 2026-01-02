# Use the official Ubuntu Noble (24.04 LTS) image as a base
FROM ubuntu:noble-20251013@sha256:c35e29c9450151419d9448b0fd75374fec4fff364a27f176fb458d472dfc9e54

# Install espup dependencies
RUN apt-get update && apt-get install -y gcc build-essential curl pkg-config

# Install rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Set environment variables for Rust
ENV PATH="/root/.cargo/bin:${PATH}"

# Install espup using cargo
RUN cargo install espup

# Install the ESP toolchain for esp32
RUN espup install

# Export the toolchain env vars to a script and auto-source it for every shell
RUN mv /root/export-esp.sh /etc/profile.d/esp-idf-env.sh
SHELL ["/bin/bash", "-c"]
ENV BASH_ENV=/etc/profile.d/esp-idf-env.sh
RUN echo 'source /etc/profile.d/esp-idf-env.sh' >> /root/.bashrc