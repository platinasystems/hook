package main

import (
	"fmt"
	"time"
)

type RetryFunction struct {
	Attempt     int
	Timeout     time.Duration
	MaxAttempts int
}

func (r *RetryFunction) Retry(fn func() error) (err error) {
	for {
		if err = fn(); err == nil {
			goto end
		}
		r.Attempt += 1
		if r.Attempt >= r.MaxAttempts {
			break
		}

		if err != nil {
			fmt.Println(fmt.Sprintf("unable to execute operation, attempt %d of %d: %v\n", r.Attempt, r.MaxAttempts, err))
		}
		time.Sleep(r.Timeout)
	}
end:
	return
}
