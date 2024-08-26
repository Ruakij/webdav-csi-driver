# Copyright 2023.

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# ---- Build ----
FROM golang:1.23-alpine AS build
WORKDIR /build
# Copy sources
ADD . .
# Get dependencies
RUN make go-build
# Compile
RUN CGO_ENABLED=0 go build -a -o webdavplugin ./cmd/webdav


# ---- Release ----
FROM alpine AS release
# Install required packages
RUN apk add --no-cache davfs2

# Copy build-target
COPY --from=build /build/webdavplugin .

ENTRYPOINT ["/webdavplugin"]
