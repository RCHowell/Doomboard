package main

import (
	"encoding/csv"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"math"
	"math/rand"
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

	JSONToTSV("./problems.json")

	// rand.Seed(time.Now().Unix())
	// ranks := map[string]map[string]int{}
	// bytes, _ := ioutil.ReadFile("./moves.json")
	// err := json.Unmarshal(bytes, &ranks)
	// if err != nil {
	// 	fmt.Println(err)
	// }
	// TSVtoJSON(ranks, "./problems.tsv")

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
		p.Id, _ = strconv.Atoi(d[0])
		p.Name = d[1]
		p.Img = d[2]
		p.Spray = d[3]
		p.Moves = d[4]
		p.Quality, _ = strconv.Atoi(d[5])
		p.GradeA, p.GradeB = GetGrade(moveRanks, p.Moves)
		problems = append(problems, p)
	}

	jsondata, err := json.MarshalIndent(problems, "", "  ")

	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	fmt.Println(string(jsondata))
}

// GetGrade returns the rounded average move difficulty
// returns [1-4],[1-4]
func GetGrade(ranks map[string]map[string]int, posString string) (int, int) {
	moves := strings.Split(posString, ",")
	total := 0
	for i := 0; i < len(moves)-1; i++ {
		a := moves[i]
		b := moves[i+1]
		total += ranks[a][b]
	}
	avg := float64(total) / float64(len(moves)-1)
	a := int(math.Round(avg))
	offset := -1 + rand.Intn(2) // -1,0,1
	if a+offset > 0 {
		a += offset
	}

	_, f := math.Modf(avg)
	b := 0
	if 0 <= f && f < 0.25 {
		b = 1
	} else if 0.25 <= f && f < .50 {
		b = 2
	} else if 0.50 <= f && f < .75 {
		b = 3
	} else {
		b = 4
	}

	return a, b
}

func JSONToTSV(filePath string) {
	problems := []Problem{}
	bytes, _ := ioutil.ReadFile(filePath)
	err := json.Unmarshal(bytes, &problems)
	if err != nil {
		fmt.Println(err)
	}

	fmt.Printf("id\tname\timg\tspray\tmoves\tquality\tgrade_a\tgrade_b\tsent\n")

	for _, p := range problems {
		fmt.Printf("%d\t%s\t%s\t%s\t%s\t%d\t%d\t%d\t%d\n",
			p.Id,
			p.Name,
			p.Img,
			p.Spray,
			p.Moves,
			p.Quality,
			p.GradeA,
			p.GradeB,
			p.Sent,
		)
	}

}
