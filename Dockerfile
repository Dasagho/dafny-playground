# Use the official Ubuntu base image
FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Create a non-root user called vscode
RUN useradd -ms /bin/bash vscode

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    wget \
    unzip \
    git \
    make \
    python3 \
    python3-pip \
    openjdk-11-jdk \
    apt-transport-https && \
    rm -rf /var/lib/apt/lists/*

# Install .NET SDK
RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y dotnet-sdk-6.0

# Clone the Dafny repository
RUN git clone https://github.com/dafny-lang/dafny.git --recurse-submodules

# Change directory
WORKDIR /dafny

# Build Dafny
RUN make exe

# Install pre-commit for code style checks
RUN pip3 install pre-commit && \
    pre-commit install

# Install Z3 solver
RUN cd Binaries && \
    wget https://github.com/Z3Prover/z3/releases/download/z3-4.12.2/z3-4.12.2-x64-glibc-2.31.zip && \
    unzip z3-4.12.2-x64-glibc-2.31.zip && \
    mv z3-4.12.2-x64-glibc-2.31 z3

# Set user to vscode
USER vscode

# Add /dafny/Scripts/dafny to PATH
ENV PATH="/dafny/Scripts:${PATH}"

# Set Dafny as the entrypoint
ENTRYPOINT ["/dafny/Scripts/dafny"]

# Run a quick test
CMD ["Scripts/quicktest.sh"]