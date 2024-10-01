#!/bin/bash

# Файл для хранения индекса текущей радиостанции
RADIO_INDEX_FILE="/tmp/current_radio_index"
MPV_SOCKET="/tmp/mpv-radio-socket"
TRACK_INFO_FILE="/tmp/radio_track_info.txt"

# Иконки для управления
PLAY_ICON=""     # Иконка воспроизведения (Nerd Font)
PAUSE_ICON=""    # Иконка паузы (Nerd Font)

# Список радиостанций: URL и названия
STATIONS=(
    "http://your-first-radio-url Radio One"
    "http://your-second-radio-url Radio Two"
    "http://your-third-radio-url Radio Three"
)

# Получаем количество станций
TOTAL_STATIONS=${#STATIONS[@]}

# Проверяем, существует ли файл с индексом
if [[ -f "$RADIO_INDEX_FILE" ]]; then
    CURRENT_INDEX=$(< "$RADIO_INDEX_FILE")
else
    CURRENT_INDEX=0
fi

# Функция для получения URL и названия текущей станции
get_current_station() {
    local station_info="${STATIONS[$CURRENT_INDEX]}"
    local station_url=$(echo "$station_info" | awk '{print $1}')
    local station_name=$(echo "$station_info" | cut -d' ' -f2-)
    echo "$station_url" "$station_name"
}

# Функция для проверки, играет ли радио
is_playing() {
    if pgrep -f "$MPV_SOCKET" > /dev/null; then
        echo "true"
    else
        echo "false"
    fi
}

# Функция для обновления информации о текущей радиостанции
update_info() {
    local status=$(is_playing)
    
    # Получаем название текущей станции
    local station_name=$(get_current_station | cut -d' ' -f2-)  # Теперь получаем полное название станции
    
    # Выбираем иконку воспроизведения/паузы
    local play_pause_icon="$PAUSE_ICON"
    if [[ "$status" == "false" ]]; then
        play_pause_icon="$PLAY_ICON"
    fi

    # Вывод для Polybar: предыдущая станция, воспроизведение/пауза, следующая станция и название
    echo "%{A1:$0 toggle:}$play_pause_icon%{A} $station_name"
}

# Функция для переключения на следующую радиостанцию
next_station() {
    CURRENT_INDEX=$(( (CURRENT_INDEX + 1) % TOTAL_STATIONS ))  # Переход к следующей станции
    echo "$CURRENT_INDEX" > "$RADIO_INDEX_FILE"

    # Если радио играет, переключаем на следующую станцию и продолжаем воспроизведение
    if [[ $(is_playing) == "true" ]]; then
        start_radio
    fi
}

# Функция для переключения на предыдущую радиостанцию
prev_station() {
    CURRENT_INDEX=$(( (CURRENT_INDEX - 1 + TOTAL_STATIONS) % TOTAL_STATIONS ))  # Переход к предыдущей станции
    echo "$CURRENT_INDEX" > "$RADIO_INDEX_FILE"

    # Если радио играет, переключаем на предыдущую станцию и продолжаем воспроизведение
    if [[ $(is_playing) == "true" ]]; then
        start_radio
    fi
}

# Функция для запуска радио
start_radio() {
    local station_url=$(get_current_station | awk '{print $1}')
    pkill -f "$MPV_SOCKET"
    mpv --no-video --input-ipc-server="$MPV_SOCKET" "$station_url" &>/dev/null &
}

# Функция для остановки радио
stop_radio() {
    pkill -f "$MPV_SOCKET"
}

# Функция для записи трека в файл
log_track() {
    local current_track=$(echo "$(date): $(get_current_station | cut -d' ' -f2-)")
    echo "$current_track" >> "$TRACK_INFO_FILE"
}

# Управляем действиями через аргументы
case "$1" in
    next)
        next_station
        ;;
    prev)
        prev_station
        ;;
    toggle)
        if [[ $(is_playing) == "true" ]]; then
            stop_radio
        else
            start_radio
        fi
        ;;
    log)
        log_track
        ;;
esac

# Обновляем информацию о текущей станции для Polybar
update_info