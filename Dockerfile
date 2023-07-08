# Start with a base image
FROM openjdk:8-jdk

# Set environment variables
ENV ANDROID_COMPILE_SDK=29
ENV ANDROID_BUILD_TOOLS=29.0.3
ENV ANDROID_SDK_TOOLS=6858069

# Install dependencies
RUN apt-get --quiet update --yes
RUN apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1

# Download and install Android SDK
RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS}_latest.zip
RUN unzip -d android-sdk-linux android-sdk.zip
RUN echo "y" | android-sdk-linux/tools/bin/sdkmanager --sdk_root=android-sdk-linux --install "platforms;android-${ANDROID_COMPILE_SDK}" "build-tools;${ANDROID_BUILD_TOOLS}"
ENV ANDROID_HOME=/android-sdk-linux

# Add Flutter SDK to the path
ENV FLUTTER_HOME=/flutter
ENV PATH=$PATH:${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin

# Download and install Flutter SDK
RUN git clone --branch stable https://github.com/flutter/flutter.git ${FLUTTER_HOME}
RUN flutter doctor

# Install Figma CLI
RUN apt-get --quiet install --yes npm
RUN npm install --global figma-cli

# Set up workspace
WORKDIR /app

# Copy the project files
COPY . .

# Install project dependencies
RUN flutter pub get

# Build the Android APK
RUN flutter build apk

# Start the app
CMD ["flutter", "run", "--release"]
