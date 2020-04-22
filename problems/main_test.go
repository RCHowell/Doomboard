package main

import (
	"github.com/stretchr/testify/assert"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"testing"
)

func TestGetGradeA(t *testing.T) {

	ranks := map[string]map[string]int{}
	bytes, _ := ioutil.ReadFile("./moves.json")
	err := json.Unmarshal(bytes, &ranks)
	if err != nil {
		fmt.Println(err)
	}
	r := GetGradeA(ranks, "AD,AE,AJ")
	assert.Equal(t, 2, r)
}
