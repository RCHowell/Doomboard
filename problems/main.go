package main

import (
	"encoding/csv"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"math"
	"os"
	"strconv"
	"strings"
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
	Sent    int    `json:"sent"`
}

func main() {

	// problems := []Problem{}
	// bytes, _ := ioutil.ReadFile("./problems.json")
	// err := json.Unmarshal(bytes, &problems)
	// if err != nil {
	// 	fmt.Println(err)
	// }

	// for _, p := range problems {
	// 	fmt.Println(p)
	// }

	ranks := map[string]map[string]int{}
	bytes, _ := ioutil.ReadFile("./moves.json")
	err := json.Unmarshal(bytes, &ranks)
	if err != nil {
		fmt.Println(err)
	}
	TSVtoJSON(ranks, "./problems.tsv")

}

func TSVtoJSON(moveRanks map[string]map[string]int, filePath string) {

	tsvFile, err := os.Open(filePath)
	if err != nil {
		fmt.Println(err)
	}
	defer tsvFile.Close()

	reader := csv.NewReader(tsvFile)
	reader.Comma = '\t'
	reader.FieldsPerRecord = -1

	data, err := reader.ReadAll()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	var problems []Problem

	for _, d := range data {
		p := Problem{}
		p.Sent, _ = strconv.Atoi(d[0])
		p.Quality, _ = strconv.Atoi(d[1])
		p.Id, _ = strconv.Atoi(d[2])
		p.Moves = d[3]
		p.Name = d[4]
		p.Img = d[5]
		p.GradeA = GetGradeA(moveRanks, d[3])
		problems = append(problems, p)
	}

	jsondata, err := json.MarshalIndent(problems, "", "  ")

	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	fmt.Println(string(jsondata))
}

// GetGradeA returns the rounded average move difficulty
// returns [1-4]
func GetGradeA(ranks map[string]map[string]int, posString string) int {
	moves := strings.Split(posString, ",")
	total := 0
	for i := 0; i < len(moves)-1; i++ {
		a := moves[i]
		b := moves[i+1]
		total += ranks[a][b]
	}
	avg := float64(total) / float64(len(moves)-1)
	return int(math.Round(avg))
}
