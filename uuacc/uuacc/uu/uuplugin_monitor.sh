#!/bin/sh

exec 2>/tmp/monitor.log || true
set -x

# Online URL
URL_PREFIX="https://"
DOWNLOAD_URL="router.uu.163.com/api/plugin?type="
UNINSTALL_DOWNLOAD_URL="router.uu.163.com/api/script/uninstall?type="

ROUTER=""
MODEL=""

ASUSWRT_MERLIN="asuswrt-merlin"
XIAOMI="xiaomi"
HIWIFI="hiwifi"
OPENWRT="openwrt"

BASEDIR="$(cd "$(dirname "$0")"; pwd -P)"
MONITOR_CONFIG="${BASEDIR}/uuplugin_monitor.config"

MONITOR_FILE="uuplugin_monitor.sh"
UPDATE_FILE="uu.update"
UNINSTALL_FILE="uu.uninstall"
RUNNING_DIR="/koolshare/uu"
PLUGIN_MOUNT_DIR=""
PLUGIN_DIR=""
PLUGIN_TAR="uu.tar.gz"
PLUGIN_EXE="uuplugin"
PLUGIN_CONF="uu.conf"
PID_FILE="/var/run/uuplugin.pid"
PLUGIN_TAR_MD5_FILE="uu.tar.gz.md5"

trap ignore_sighup SIGHUP
ignore_sighup() { 
    true;
}

get_mount_point() {
    [ $# -ne 1 ] && return 1

    local mount_point=$1
    while true
    do
        if [ "$mount_point" = "/" ]
        then
            break
        fi

        if [ ! -z "$(df -k | grep -m 1 -E "[ \t]+$mount_point[ \t]*$" | grep -v 'grep')" ]
        then
            break
        fi

        mount_point=$(dirname $mount_point)
    done
    echo $mount_point
    return 0
}

init_param() {
    local router=$(grep "router=" "${MONITOR_CONFIG}" | head -n1 | cut -d= -f2)
    local model=$(grep "model=" "${MONITOR_CONFIG}" | head -n1 | cut -d= -f2)
    [ -z "${router}" ] && return 1

    if [ "${router}" = "${ASUSWRT_MERLIN}" ] && [ -z "${model}" ];then
        model=$(nvram get productid)
    fi

    ROUTER="${router}"
    MODEL="${model}"
    # TO LOWER
    MODEL=$(echo "${MODEL}" | sed 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/')
    [ "$?" != "0" ] && return 1

    case ${ROUTER} in
        ${ASUSWRT_MERLIN})
            PLUGIN_DIR="/jffs/uu"
            ;;
        ${XIAOMI})
            PLUGIN_DIR="/data/uu"
            ;;
        ${HIWIFI})
            PLUGIN_DIR="/plugins/uu"
            ;;
        ${OPENWRT})
            PLUGIN_DIR="/koolshare/uu"
            ;;
        *)
            return 1
            ;;
    esac

    PLUGIN_MOUNT_DIR=$(get_mount_point "${PLUGIN_DIR}") || return 1
    [ ! -d "${PLUGIN_MOUNT_DIR}" ] && return 1
    return 0
}

download_url_init() {
    local info=$(ip addr show br0)
    if [ "$info" = "" ];then
        info=$(ip addr show br-lan)
    fi
    local sn=$(echo "${info}" | grep "link/ether" | awk '{print $2}')

    case ${ROUTER} in
        ${ASUSWRT_MERLIN})
            asuswrt_download_url_init
            DOWNLOAD_URL="${DOWNLOAD_URL}&sn=${sn}"
            return $?
            ;;
        ${XIAOMI})
            xiaomi_download_url_init
            DOWNLOAD_URL="${DOWNLOAD_URL}&sn=${sn}"
            return $?
            ;;
        ${HIWIFI})
            hiwifi_download_url_init
            DOWNLOAD_URL="${DOWNLOAD_URL}&sn=${sn}"
            return $?
            ;;
        ${OPENWRT})
            openwrt_download_url_init
            DOWNLOAD_URL="${DOWNLOAD_URL}"
            return $?
            ;;
        *)
            return 1
            ;;
    esac
}

xiaomi_download_url_init() {
    [ -z "${MODEL}" ] && return 1

    URL_PREFIX="http://"
    DOWNLOAD_URL="${URL_PREFIX}${DOWNLOAD_URL}"
    UNINSTALL_DOWNLOAD_URL="${URL_PREFIX}${UNINSTALL_DOWNLOAD_URL}${XIAOMI}"

    case ${MODEL} in
        "r3" | "r1cm")
            DOWNLOAD_URL="${DOWNLOAD_URL}xiaomi-3-openwrt-stock"
            return 0
            ;;
        "r3d")
            DOWNLOAD_URL="${DOWNLOAD_URL}xiaomi-3d-openwrt-stock"
            return 0
            ;;
        "r3p" | "r3g" | "r3c" | "r3gv2")
            DOWNLOAD_URL="${DOWNLOAD_URL}xiaomi-3p-openwrt-stock"
            return 0
            ;;
        "r1d" | "r2d")
            DOWNLOAD_URL="${DOWNLOAD_URL}xiaomi-1d-openwrt-stock"
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

openwrt_download_url_init() {
    URL_PREFIX="http://"
    DOWNLOAD_URL="${URL_PREFIX}${DOWNLOAD_URL}"
    UNINSTALL_DOWNLOAD_URL="${URL_PREFIX}${UNINSTALL_DOWNLOAD_URL}${OPENWRT}"

    arm=$(echo "${MODEL}" | grep "arm")
    if [ "" != ${arm} ];then
        DOWNLOAD_URL="${DOWNLOAD_URL}openwrt-arm"
        return 0
    fi

    aarch64=$(echo "${MODEL}" | grep "aarch64")
    if [ "" != ${aarch64} ];then
        DOWNLOAD_URL="${DOWNLOAD_URL}openwrt-aarch64"
        return 0
    fi

    mips=$(echo "${MODEL}" | grep "mips")
    if [ "" != ${mips} ];then
        DOWNLOAD_URL="${DOWNLOAD_URL}openwrt-mipsel"
        return 0
    fi

    x86_64=$(echo "${MODEL}" | grep "x86_64")
    if [ "" != ${x86_64} ];then
        DOWNLOAD_URL="${DOWNLOAD_URL}openwrt-x86_64"
        return 0
    fi
    return 1
}

hiwifi_download_url_init() {
    [ -z "${MODEL}" ] && return 1

    DOWNLOAD_URL="${URL_PREFIX}${DOWNLOAD_URL}"
    UNINSTALL_DOWNLOAD_URL="${URL_PREFIX}${UNINSTALL_DOWNLOAD_URL}${HIWIFI}"

    case ${MODEL} in
        "hc5661" | "hc5661a" | "c312a" | "c312b" | "hc5861" | "hc5962" | \
            "hc5761" | "hc5761a" | "b70" | "r33" | "bbf" | "b50" | "b51" | "hc5663")
            DOWNLOAD_URL="${DOWNLOAD_URL}gee-mtmips-openwrt-stock"
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

asuswrt_download_url_init() {
    local model=$(nvram get model)
    local productid=$(nvram get productid)
    if [ "" != "${productid}" ];then
        model=${productid}
    fi

    local arm=$(cat /proc/cpuinfo | grep "CPU architecture" | cut -d' ' -f3 | head -n1)
    local mips=$(cat /proc/cpuinfo | grep 'cpu model' | grep -m1 "MIPS")

    DOWNLOAD_URL="${URL_PREFIX}${DOWNLOAD_URL}"
    UNINSTALL_DOWNLOAD_URL="${URL_PREFIX}${UNINSTALL_DOWNLOAD_URL}asuswrt-merlin"

    case "${model}" in
        RT-AC56U)
            DOWNLOAD_URL="${DOWNLOAD_URL}asuswrt-merlin-ac56u"
            return 0
            ;;
        RT-AC68U)
            DOWNLOAD_URL="${DOWNLOAD_URL}asuswrt-merlin-ac68u"
            return 0
            ;;
        RT-AC87U)
            DOWNLOAD_URL="${DOWNLOAD_URL}asuswrt-merlin-ac87u"
            return 0
            ;;
        RT-AC88U)
            DOWNLOAD_URL="${DOWNLOAD_URL}asuswrt-merlin-ac88u"
            return 0
            ;;
        RT-AC5300)
            DOWNLOAD_URL="${DOWNLOAD_URL}asuswrt-merlin-ac5300"
            return 0
            ;;
        GT-AC5300)
            DOWNLOAD_URL="${DOWNLOAD_URL}asuswrt-merlin-gtac5300"
            return 0
            ;;
        RT-AX86U)
            DOWNLOAD_URL="${DOWNLOAD_URL}asuswrt-merlin-rtax86u"
            return 0
            ;;
        RT-AX82U)
            DOWNLOAD_URL="${DOWNLOAD_URL}asuswrt-merlin-rtax82u"
            return 0
            ;;
        R6300V2)
            DOWNLOAD_URL="${DOWNLOAD_URL}netgear-merlin-r6300v2"
            return 0
            ;;
        R6400)
            DOWNLOAD_URL="${DOWNLOAD_URL}netgear-merlin-r6400"
            return 0
            ;;
        EA6400)
            DOWNLOAD_URL="${DOWNLOAD_URL}linksys-merlin-ea6400"
            return 0
            ;;
        *)
            if [ "${arm}" = "7" ];then
                DOWNLOAD_URL="${DOWNLOAD_URL}merlin-armv7"
                return 0
            fi
            if [ "${arm}" = "8" ];then
                DOWNLOAD_URL="${DOWNLOAD_URL}merlin-armv8"
                return 0
            fi

            if [ ! -z "${mips}" ];then
                DOWNLOAD_URL="${DOWNLOAD_URL}merlin-mips"
                return 0
            fi
            ;;
    esac
    return 1
}

system_init() {
    ulimit -HS -s 8192
}

check_dir() {
    if [ ! -d "${RUNNING_DIR}" ];then
        mkdir -p "${RUNNING_DIR}" >/dev/null 2>&1
        [ "$?" != "0" ] && return 1
    fi

    if [ ! -d "${PLUGIN_DIR}" ];then
        mkdir -p "${PLUGIN_DIR}" >/dev/null 2>&1
        [ "$?" != "0" ] && return 1
    fi
    return 0
}

check_plugin_file() {
    # One of ${exefile}, ${runtar}, ${backtar} must exist.
    local exefile="${RUNNING_DIR}/${PLUGIN_EXE}"
    local runtar="${RUNNING_DIR}/${PLUGIN_TAR}"
    local backtar="${PLUGIN_DIR}/${PLUGIN_TAR}"

    if [ ! -e "${exefile}" ] && [ ! -e "${runtar}" ] && [ ! -e "${backtar}" ];then
        download_acc "${runtar}"
    fi
}

# Return: 0 means running.
check_running() {
    if [ -f "$PID_FILE" ];then
        pid=$(cat $PID_FILE)
        running_pid=$(ps | sed 's/^[ \t ]*//g;s/[ \t ]*$//g' | \
            sed 's/[ ][ ]*/#/g' | grep "${PLUGIN_EXE}" | \
            grep -v "grep" | cut -d'#' -f1 | grep -e "^${pid}$")
        if [ "$pid" = "${running_pid}" ];then
            return 0
        fi
    fi
    return 1
}

# Return: 0 means update flag is set.
check_update() {
    if [ -f "${RUNNING_DIR}/${UPDATE_FILE}" ];then
        return 0
    else
        return 1
    fi
}

# Return: 0 means uninstall flag is set.
check_uninstall() {
    if [ -f "${RUNNING_DIR}/${UNINSTALL_FILE}" ];then
        return 0
    else
        return 1
    fi
}

# Return: 0 means success.
download() {
    local url="$1"
    local file="$2"
    local plugin_info=$(curl -L -s -k -H "Accept:text/plain" "${url}" || \
        wget -q --no-check-certificate -O - "${url}&output=text" || \
        curl -s -k -H "Accept:text/plain" "${url}"
    )

    [ "$?" != "0" ] && return 1
    [ -z "$plugin_info" ] && return 1

    local plugin_url=$(echo "$plugin_info" | cut  -d ',' -f 1)
    local plugin_md5=$(echo "$plugin_info" | cut  -d ',' -f 2)

    [ -z "${plugin_url}" ] && return 1
    [ -z "${plugin_md5}" ] && return 1

    curl -L -s -k "$plugin_url" -o "${file}" >/dev/null 2>&1 || \
        wget -q --no-check-certificate "$plugin_url" -O "${file}" >/dev/null 2>&1 || \
        curl -s -k "$plugin_url" -o "${file}" >/dev/null 2>&1

    if [ "$?" != "0" ];then
        echo "Failed: curl (-L) -s -k ${plugin_url} -o ${file} ||
            wget -q --no-check-certificate $plugin_url -O ${file}"
        # Clean up
        [ -f "${file}" ] && rm "${file}"
        return 1
    fi

    if [ -f "${file}" ];then
        local download_md5=$(md5sum "${file}")
        local download_md5=$(echo "$download_md5" | sed 's/[ ][ ]*/ /g' | cut -d' ' -f1)
        if [ "$download_md5" != "$plugin_md5" ];then
            rm "${file}"
            return 1
        fi
        return 0
    else
        return 1
    fi
}

# $1: FileName to where content to be saved.
# Return: 0 means success.
download_acc() {
    download "${DOWNLOAD_URL}" "$1"
    return $?
}

# $1: FileName of which md5sum will be saved.
# $2: FileName where md5sum will be saved.
save_md5sum() {
    [ ! -f "${1}" ] && return
    touch "${2}"

    local filemd5sum=$(md5sum "$1")
    filemd5sum=$(echo "${filemd5sum}" | sed 's/[ ][ ]*/ /g' | cut -d' ' -f1)
    echo "File md5sum: ${filemd5sum}"
    echo "${filemd5sum}" > "${2}"
}

check_backtar_file() {
    local runtar="${RUNNING_DIR}/${PLUGIN_TAR}"
    local backtar="${PLUGIN_DIR}/${PLUGIN_TAR}"
    local md5file="${PLUGIN_DIR}/${PLUGIN_TAR_MD5_FILE}"

    if [ ! -e "${backtar}" ];then
        download_acc "${runtar}"
        if [ "$?" != "0" ]; then
            [ -f "${runtar}" ] && rm "${runtar}"
            return
        fi

        local exefile="${RUNNING_DIR}/${PLUGIN_EXE}"
        tar zxvf "${runtar}" -C "${RUNNING_DIR}"
        [ "$?" != "0" ] && return
        chmod u+x "${exefile}"
        ${exefile} -v >/dev/null 2>&1
        [ "$?" != "0" ] && return

        check_space
        if [ "$?" = "0" ];then
            cp "${runtar}" "${backtar}"
            if [ "$?" != "0" ]; then
                [ -f "${backtar}" ] && rm "${backtar}"
                [ -f "${runtar}" ] && rm "${runtar}"
                return
            fi

            save_md5sum "${runtar}" "${md5file}"
        else
            echo "No enough space is available."
        fi

        [ -f "${runtar}" ] && rm "${runtar}"
        return
    fi

    [ -f "${md5file}" ] && return
    save_md5sum "${backtar}" "${md5file}"
}

# $1: FileName of which md5sum to be checked.
# $2: FileName that contains md5.
# Return: 0 means success.
check_md5sum() {
    [ ! -f "$1" -o ! -f "$2" ] && return 1

    local plugin_md5=$(md5sum "$1")
    [ "$?" != "0" ] && return 1

    local right_md5=$(cat "${2}")
    [ "$?" != "0" ] && return 1

    plugin_md5=$(echo "$plugin_md5" | sed 's/[ ][ ]*/ /g' | cut -d' ' -f1)
    if [ "$right_md5" != "$plugin_md5" ];then
        echo "Error: md5 does not match."
        return 1
    fi
    return 0
}

# Check if enough space is available in flash.
# Return: 0 means enough space is available; other mean errors.
check_space() {
    local df_res=$(df -k | grep -m 1 -E "[ \t]+${PLUGIN_MOUNT_DIR}[ \t]*$" | grep -v "grep")
    [ -z "${df_res}" ] && return 0

    df_res=$(echo "${df_res}" | sed 's/[ ][ ]*/#/g')
    local available=$(echo "${df_res}" | cut -d'#' -f4)
    echo "Available space is ${available}"

    [ "${available}" -ge 500 ] && return 0
    return 1
}

# Check if need to upgrade the jffs one plugin copy.
# The old copy will be deleted if require upgrade
# Return: no return value, continue on any failure
check_plugin_upgrade() {
    # get latest plugin release info
    local latest_plugin_info=$(curl -L -s -k -H "Accept:text/plain" "${DOWNLOAD_URL}" || \
        wget -q --no-check-certificate -O - "${DOWNLOAD_URL}&output=text" || \
        curl -s -k -H "Accept:text/plain" "${DOWNLOAD_URL}"
    )

    [ "$?" != "0" ] && return
    [ -z "$latest_plugin_info" ] && return

    local latest_plugin_md5=$(echo "$latest_plugin_info" | cut  -d ',' -f 2)
    [ -z "${latest_plugin_md5}" ] && return

    # get local md5
    local local_plugin_md5=$(cat ${PLUGIN_DIR}/${PLUGIN_TAR_MD5_FILE} 2>/dev/null)
    [ "$?" != "0" ] && return

    #compare md5
    if [ "$local_plugin_md5" != "$latest_plugin_md5" ]; then
        # delete local plugin copy and force to upgrade to latest
        rm -f "${PLUGIN_DIR}/${PLUGIN_TAR}" "${PLUGIN_DIR}/${PLUGIN_TAR_MD5_FILE}"
    fi
}

start_acc() {
    # Start order:
    # 1. ${exefile}
    # 2. ${runtar}
    # 3. ${backtar}

    local exefile="${RUNNING_DIR}/${PLUGIN_EXE}"
    local runtar="${RUNNING_DIR}/${PLUGIN_TAR}"
    local backtar="${PLUGIN_DIR}/${PLUGIN_TAR}"
    local confile="${RUNNING_DIR}/${PLUGIN_CONF}"

    if [ -e "${exefile}" ];then
        chmod u+x "${exefile}"
        ${exefile} "${confile}" >/dev/null 2>&1 &
        return
    fi

    if [ -f "${runtar}" ];then
        tar zxvf "${runtar}" -C "${RUNNING_DIR}" 
        if [ "$?" = "0" ];then
            chmod u+x "${exefile}"
            ${exefile} "${confile}" >/dev/null 2>&1 &

            # ${runtar} is not needed any more.
            rm "${runtar}"
            return
        fi
    fi

    if [ -f "${backtar}" ];then
        check_md5sum "${backtar}" "${PLUGIN_DIR}/${PLUGIN_TAR_MD5_FILE}"
        if [ "$?" != "0" ];then
            # Download a new one. Next time ${runtar} will be used.
            download_acc "${runtar}"
            return
        fi

        tar zxvf "${backtar}" -C "${RUNNING_DIR}"
        if [ "$?" != "0" ];then
            return
        fi

        chmod u+x "${exefile}"
        ${exefile} "${confile}" >/dev/null 2>&1 &
        return
    else
        # Download a new one. Next time ${runtar} will be used.
        download_acc "${runtar}"
        return
    fi
}

check_acc() {
    cd $RUNNING_DIR

    check_running
    [ "$?" = "0" ] && return

    check_uninstall
    if [ "$?" = "0" ];then
        # Download uninstall script to uninstall ourself.
        local uninstall_script="${RUNNING_DIR}/uninstall.sh"
        local uninstall_flag="${RUNNING_DIR}/${UNINSTALL_FILE}"

        download "${UNINSTALL_DOWNLOAD_URL}" "${uninstall_script}"
        if [ "$?" != "0" ];then
            [ -f "${uninstall_flag}" ] && rm ${uninstall_flag}
            [ -f "${uninstall_script}" ] && rm ${uninstall_script}
            start_acc
            return
        else
            chmod u+x ${uninstall_script}
            /bin/sh ${uninstall_script} "${ROUTER}" "${MODEL}" >/dev/null 2>&1 &
            # Waiting to be uninstalled.
            sleep 20
            return
        fi
    fi

    check_update
    if [ "$?" != "0" ];then
        # "uuplugin" is not running, and no need to be updated.
        # Just try to start again.
        start_acc
        return
    fi

    # Try to update.
    local exefile="${RUNNING_DIR}/${PLUGIN_EXE}"
    local runtar="${RUNNING_DIR}/${PLUGIN_TAR}"
    local backtar="${PLUGIN_DIR}/${PLUGIN_TAR}"

    download_acc "${runtar}"
    if [ "$?" != "0" ];then
        # Download failed; Just try to start again.
        [ -f "${runtar}" ] && rm "${runtar}"
        start_acc
        return
    fi

    rm $(ls | grep -v "$MONITOR_FILE" | grep -v "$PLUGIN_TAR")
    # 刚下载的插件，不需要重新检查md5
    tar zxvf "${runtar}" -C "${RUNNING_DIR}"
    if [ "$?" != "0" ];then
        # Clean up.
        rm $(ls | grep -v "$MONITOR_FILE")
        start_acc
        return
    fi

    chmod u+x "${exefile}"
    ${exefile} "${RUNNING_DIR}/$PLUGIN_CONF" >/dev/null 2>&1 &

    # If uuplugin fails to start in 5 seconds, something wrong must happened.
    # Then give up what we have done.
    local TIMES="1 2 3 4 5"
    local not_running=1
    for i in ${TIMES};do
        check_running
        if [ "$?" = "0" ];then
            not_running=0
            break
        else
            sleep 1
        fi
    done

    if [ "${not_running}" = "1" ];then
        rm ${RUNNING_DIR}/*
        start_acc
        return
    fi

    # Check if flash space is enough
    rm ${backtar}
    check_space
    if [ "$?" = "0" ];then
        local backtar_md5file="${PLUGIN_DIR}/${PLUGIN_TAR_MD5_FILE}"
        cp ${runtar} ${backtar}
        if [ "$?" != "0" ];then
            [ -f "${backtar}" ] && rm "${backtar}"
            [ -f "${backtar_md5file}" ] && rm "${backtar_md5file}"
            rm ${runtar}
            echo "Update operation failed."
            return
        fi

        save_md5sum "${runtar}" "${backtar_md5file}"

        echo "Update operation succeeded."
        rm ${runtar}
        return
    else
        echo "Warning: no enough space is available."
        echo "Update operation failed."
        rm ${runtar}
        return
    fi
}

init_param
[ "$?" != "0" ] && exit 1

download_url_init
[ "$?" != "0" ] && exit 1

system_init
check_dir
[ "$?" != "0" ] && exit 1

check_plugin_upgrade

while :
do
    check_backtar_file
    check_plugin_file
    check_acc
    sleep 1
    check_running
    set +x
    exec 2>/dev/null || true
    if [ "$?" = "0" ];then
        # Plugin is running, so we will check again in 60 seconds.
        sleep 60
    else
        # Plugin is not running now, so check it more frequently.
        sleep 5
    fi
done
