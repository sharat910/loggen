package main

import (
	"flag"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"os"
	"time"
)
func main() {
	debug := flag.Bool("debug", false, "sets log level to debug")
	flag.Parse()

	consoleWriter := zerolog.ConsoleWriter{Out: os.Stdout}
	f, err := os.Create("./logs/log.txt")
	if err != nil {
		log.Fatal().Err(err).Send()
	}
	multi := zerolog.MultiLevelWriter(consoleWriter, f)
	log.Logger = zerolog.New(multi).With().Timestamp().Logger()

	zerolog.SetGlobalLevel(zerolog.InfoLevel)
	if *debug {
		zerolog.SetGlobalLevel(zerolog.DebugLevel)
	}

	log.Debug().Msg("Log level set to Debug")
	log.Info().Msg("Log level set to Info")

	t1 := time.NewTicker(time.Second)
	t10 := time.NewTicker(100 * time.Millisecond)
	i := 0
	j := 0
	for {
		select {
		case <-t1.C:
			i+=1
			log.Info().
				Int("seconds", i).
				Int("milliseconds", j).
				Send()
		case <-t10.C:
			j+=100
			log.Debug().
				Int("seconds", i).
				Int("milliseconds", j).
				Send()
		}
	}
}
