# Go — toolchain

> Installed via dotfiles: `brew install go` (macOS) or `apt install golang-go` (Linux desktop profile).
> Neovim: `gopls` + `gofumpt` via Mason — see [neovim-ide.md](neovim-ide.md#go).

## Quick commands

```bash
go version
go mod init example.com/foo    # new module
go mod tidy                    # sync go.mod / go.sum
go build ./...
go test ./...
go run .
go install ./cmd/foo@latest    # binary → $(go env GOPATH)/bin
```

## Env

```bash
go env GOPATH    # default ~/go
go env GOROOT
```

`conf/zsh/zshrc` prepends `$(go env GOPATH)/bin` to `PATH`.

## New project checklist

1. `go mod init …`
2. Open folder in nvim → `:MasonInstall gopls gofumpt` if needed
3. `<leader>lf` to format · `gd` / `gr` for LSP navigation
