# Use archlinux as the base image
FROM archlinux

# Set locale to ru_RU.utf8
ENV LANG ru_RU.utf8

# Define arguments and environment variables
ARG NGROK_TOKEN
ARG PASSWORD
ENV PASSWORD=${PASSWORD}
ENV NGROK_TOKEN=${NGROK_TOKEN}

# Install ssh, wget, and unzip
RUN yes | pacman -Suy
RUN yes | pacman -S openssh wget unzip

# Download and unzip ngrok
RUN wget -O ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip > /dev/null 2>&1
RUN unzip ngrok.zip

# Create shell script
RUN ./ngrok config add-authtoken ${NGROK_TOKEN}

RUN systemctl enable sshd
RUN echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config # Allow root login via SSH
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config  # Allow password authentication
RUN echo root:${PASSWORD}|chpasswd # Set root password
RUN systemctl enable sshd

# Expose port
EXPOSE 80 8888 8080 443 5130 5131 5132 5133 5134 5135 3306

RUN ./ngrok tcp 22
