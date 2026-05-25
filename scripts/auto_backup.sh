#!/bin/bash

# =========================
# CONFIG
# =========================

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DATA_DIR="$BASE_DIR/data"
BACKUP_DIR="$BASE_DIR/backups"
LOG_DIR="$BASE_DIR/logs"
LOG_FILE="$LOG_DIR/backup.log"

# Màu terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# =========================
# FUNCTION BACKUP
# =========================

backup_data() {

    # Kiểm tra thư mục backup
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
    fi

    # Kiểm tra thư mục log
    if [ ! -d "$LOG_DIR" ]; then
        mkdir -p "$LOG_DIR"
    fi

    # Kiểm tra internet
    echo -e "${BLUE}Checking Internet connection...${NC}"

    if ping -c 1 google.com &> /dev/null
    then
        echo -e "${GREEN}Internet Connected${NC}"
    else
        echo -e "${RED}No Internet Connection${NC}"
    fi

    # Tạo file backup
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    BACKUP_FILE="backup_$TIMESTAMP.tar.gz"

    tar -czf "$BACKUP_DIR/$BACKUP_FILE" -C "$BASE_DIR" data

    echo "[$(date)] Backup created: $BACKUP_FILE" >> "$LOG_FILE"

    echo -e "${GREEN}Backup completed successfully!${NC}"

    # =========================
    # BONUS:
    # Chỉ giữ 5 file backup mới nhất
    # =========================

    cd "$BACKUP_DIR"

    ls -tp | grep -v '/$' | tail -n +6 | xargs -I {} rm -- {}

    echo -e "${YELLOW}Old backups cleaned!${NC}"
}

# =========================
# VIEW BACKUPS
# =========================

view_backups() {
    echo -e "${BLUE}===== BACKUP FILES =====${NC}"
    ls -lh "$BACKUP_DIR"
}

# =========================
# VIEW LOG
# =========================

view_logs() {
    echo -e "${BLUE}===== BACKUP LOG =====${NC}"
    cat "$LOG_FILE"
}

# =========================
# MENU
# =========================

while true
do
    echo -e "${YELLOW}"
    echo "==============================="
    echo " STUDENT BACKUP SYSTEM "
    echo "==============================="
    echo -e "${NC}"

    echo "1. Backup dữ liệu"
    echo "2. Xem danh sách backup"
    echo "3. Xem log"
    echo "4. Thoát"

    read -p "Chọn chức năng: " choice

    case $choice in
        1)
            backup_data
            ;;
        2)
            view_backups
            ;;
        3)
            view_logs
            ;;
        4)
            echo -e "${GREEN}Exit Program${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Lựa chọn không hợp lệ!${NC}"
            ;;
    esac

done
