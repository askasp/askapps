
export GCP_CREDENTIALS=$(cat /home/ask/git/.secrets/askapps-7b6e83304aa0.json)
export BUCKET=stadler_no_test
mix deps.get
iex -S mix phx.server
