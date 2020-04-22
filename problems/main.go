package main

import (
	"bufio"
	"fmt"
	"os"
)

type Problem struct {
	Id      int    `json:"id"`
	Name    string `json:"name"`
	Img     string `json:"img"`
	Spray   string `json:"spray"`
	Moves   string `json:"moves"`
	Quality int    `json:"quality"`
	GradeA  int    `json:"grade_a"`
	GradeB  int    `json:"grade_b"`
	sent    bool   `json:"sent"`
}

func main() {

}

func listToProblems(filePath string) []Problem {

	result := []Problem{}
	f, err := os.Open(filePath)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	defer f.Close()

	i := 0
	scanner := bufio.NewScanner(f)
	for scanner.Scan() {
		moves := scanner.Text()
	}

	return result

}
