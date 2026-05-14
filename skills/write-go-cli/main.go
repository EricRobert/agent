package main

import (
	"context"
	"fmt"

	"github.com/lachaloupe/cli"
)

//go:generate go tool cligen

var CLI = cli.Command{
	Handler: Run,
}

type Args struct {
	Name string
}

func Run(ctx context.Context, args Args) error {
	fmt.Println("hello", args.Name)
	return nil
}

func main() {
	CLI.Main()
}
