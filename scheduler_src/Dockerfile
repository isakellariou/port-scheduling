# DockerFile for creating Port Scheduler Container
# Use the official Ubuntu base image
FROM ubuntu:latest

# Set environment variables
ENV ECLIPSE_PROLOG_URL="https://eclipseclp.org/Distribution/Builds/7.1_13/x86_64_linux/eclipse_basic.tgz"

# Install necessary dependencies
RUN apt-get update \
    && apt-get install -y \
        wget \
        tar \
        curl \
    && rm -rf /var/lib/apt/lists/*

# Download and extract Eclipse Prolog runtime
WORKDIR /opt/eclipse_prolog
RUN wget "$ECLIPSE_PROLOG_URL" -O eclipse_basic.tgz \
    && tar -xzvf eclipse_basic.tgz \
    && rm eclipse_basic.tgz
# Installation    
RUN printf "\n\n\nss" | ./RUNME

# Set environment variables for Eclipse Prolog
ENV PATH="/opt/eclipse_prolog/bin/x86_64_linux:${PATH}"

# Set the working directory
WORKDIR /port_scheduler

# Copy your Prolog files into the container
COPY http_method.ecl /port_scheduler/
COPY scheduler.ecl port_scheduling.ecl port_main.ecl port_map.ecl /port_scheduler/ 
COPY problem_related.ecl /port_scheduler/
COPY port_json_interface.ecl /port_scheduler/
COPY errors.ecl /port_scheduler
COPY data/map.ecl /port_scheduler/data/

COPY ./http_server_v11 /port_scheduler/http_server_v11/

# Entry point (replace with the appropriate command to start your application)
CMD ["eclipse", "-f", "scheduler.ecl", "-e","run_port_scheduler"]
