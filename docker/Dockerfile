# Base image
FROM alpine:3.19.0

# Environment variables
ENV PORT=25565 \
    SERVER_TYPE=purpur \
    VERSION=1.20.4 \
    BUILD=2128 \
    EULA=true

# Working directory
WORKDIR /server

# Install dependencies
RUN apk add --no-cache openjdk17 screen wget bash vsftpd

# Configure vsftpd
RUN echo "anonymous_enable=YES\nlocal_enable=YES\nwrite_enable=YES\nlocal_umask=022\nanon_upload_enable=YES\nanon_mkdir_write_enable=YES\nanon_other_write_enable=YES\nchroot_local_user=YES\nlisten=YES\nlisten_ipv6=NO\npam_service_name=vsftpd\nuserlist_enable=YES\ntcp_wrappers=YES" > /etc/vsftpd/vsftpd.conf

# Create FTP user
RUN adduser -D -h /server ftpuser && echo "ftpuser:ftppassword" | chpasswd


# Download server JAR
RUN wget https://api.purpurmc.org/v2/purpur/${VERSION}/$BUILD/download -O server.jar

# Create EULA file
RUN echo "eula=$EULA" > eula.txt

# Create server manager script# Download server manager script
RUN wget https://raw.githubusercontent.com/Sijon20/minecraft-server/main/minecraft-server.sh -O manager-mc.sh && chmod +x manager-mc.sh

# Expose port $PORT and 21
EXPOSE $PORT 21


# CMD instruction
CMD (vsftpd /etc/vsftpd/vsftpd.conf &) && ./manager-mc.sh start

# Healthcheck
HEALTHCHECK --interval=1m --timeout=10s CMD wget --quiet --tries=1 --spider http://localhost:$PORT || exit 1
