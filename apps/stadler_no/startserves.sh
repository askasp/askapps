
export GCP_CREDENTIALS=$(cat /home/ask/git/.secrets/askapps-7b6e83304aa0.json)
export BUCKET=stadler_no_test
export IPINFO_API_KEY=9218470f478ec9
mix deps.get
iex -S mix phx.server
