

# =============================================================================

DEV_DOCKER_IMAGE="mattwiley/node-dev:16.x"
ADDITIONAL_DOCKER_CONFIG='-p 3000:3000'

# =============================================================================
# =============================================================================

function drh {
    # "Docker Run Here"
    # ref: https://gist.github.com/matt-wiley/e1063d877386b0425ab6e912c8f5a59b
    # Simplfies running Docker container with current working directory mounted in.
    docker run -dit --rm -v "$(pwd):$(pwd)" -w "$(pwd)" "${@}"
}

function dev_container {
    local container_name="$(pwd | xargs basename)"
    case "${1}" in
        "start")
            shift
            # echo "Checking for dev container."
            if $(docker exec "${container_name}" sh 2>/dev/null ); then
                : # echo "Dev container found."
            else 
                drh --name ${container_name} ${ADDITIONAL_DOCKER_CONFIG} ${DEV_DOCKER_IMAGE} 2>&1>&-
            fi
            ;;
        "exec")
            shift
            # echo "Checking for dev container."
            if $(docker exec "${container_name}" sh 2>/dev/null); then
                # echo "Dev container found."
                docker exec -it "${container_name}" "${@}"
            else 
                : # echo "Dev container not found."
                dev_container start
                docker exec -it "${container_name}" "${@}"
            fi
            ;;
        *)
            ;;
    esac
}


alias node='dev_container exec node'
alias npm='dev_container exec npm'