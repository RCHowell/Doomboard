package main

import (
	"reflect"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestReflect(t *testing.T) {
	m := [][]string{
		{"a", "b", "c"},
		{"d", "e", "f"},
		{"g", "h", "i"},
	}
	// upper right should be reflected
	expected := [][]string{
		{"a", "b", "c"},
		{"b", "e", "f"},
		{"c", "f", "i"},
	}
	Reflect(m)
	assert.True(t, reflect.DeepEqual(expected, m))
}

func TestGenProblems(t *testing.T) {
	moves := map[string]map[string]int{
		"X": {
			"Y": 0,
			"Z": 0,
		},
		"Y": {
			"X": 0,
			"Z": 0,
		},
		"Z": {
			"Y": 0,
		},
	}
	problem := make([]string, 0)
	GenProblems("X", problem, moves)
}
