cleanup_brew() {
    brew cleanup --force
    rm -rf "$(brew --cache)"
}

final_message() {
    clear
    echo "All the automated scripts have now finished. DONE √√√"
}

cleanup_brew
final_message
