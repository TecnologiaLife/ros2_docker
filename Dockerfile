# Ubuntu 24.04 ベースのROS 2 jazzyイメージ
FROM ubuntu:22.04

# 環境変数の設定
ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO=jazzy
ENV ROS_ROOT=/opt/ros/jazzy
ENV ROS_PACKAGE_PATH=$ROS_ROOT/share
ENV PATH=$ROS_ROOT/bin:$PATH
ENV LD_LIBRARY_PATH=$ROS_ROOT/lib:$LD_LIBRARY_PATH

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y \
    locales \
    curl \
    gnupg2 \
    lsb-release \
    && locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
    && apt-get clean


RUN apt-get install -y python3-pip

# 使用するPythonライブラリのインストール
RUN pip install \
    setuptools==68


CMD ["/bin/bash"]

# ROS 2 jazzy のリポジトリキーを追加
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | apt-key add - \
    && echo "deb http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list

# ROS 2 jazzy のインストール
RUN apt-get update && apt-get install -y \
    ros-jazzy-desktop \
    python3-colcon-common-extensions \
    python3-rosdep \
    python3-argcomplete \
    && apt-get clean

# rosdep の初期化
RUN rosdep init && rosdep update

# エントリポイントを設定（ROS 2 のセットアップ）
RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc
ENTRYPOINT ["/bin/bash", "-c", "source /opt/ros/jazzy/setup.bash && exec bash"]