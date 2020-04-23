package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"math/rand"
	"os"
	"strconv"
	"strings"
	"time"
)

const (
	MoveCount = 4
)

func main() {

	// Uncomment to print JSON graph from adjancency-matrix csv
	// toJSON(os.Args[1])

	// Uncomment to relfect adjacency-matrix csv
	// m := toMatrix(os.Args[1])
	// Reflect(m)
	// toDelimited(m,",")

	rand.Seed(time.Now().Unix())
	moves := map[string]map[string]int{}
	bytes, _ := ioutil.ReadFile("./moves.json")
	_ = json.Unmarshal(bytes, &moves)
	for _, p := range positions {
		problem := make([]string, 0)
		GenProblems(p, problem, moves)
	}
}

func toJSON(filePath string) {

	result := map[string]map[string]int{}

	f, err := os.Open(filePath)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	defer f.Close()

	i := 0
	scanner := bufio.NewScanner(f)

	for scanner.Scan() {
		startPosition := positions[i]
		moves := make(map[string]int, 0)
		line := scanner.Text()
		moveWeights := strings.Split(line, ",")
		for j, mw := range moveWeights {
			w, _ := strconv.Atoi(mw)
			if w > 1 {
				w--
				moves[positions[j]] = w
			}
		}
		result[startPosition] = moves
		i++
	}
	bytes, _ := json.MarshalIndent(result, "", " ")
	fmt.Fprint(os.Stdout, string(bytes))
}

func toMatrix(filePath string) [][]string {

	result := [][]string{}
	f, err := os.Open(filePath)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	defer f.Close()

	i := 0
	scanner := bufio.NewScanner(f)
	for scanner.Scan() {
		result = append(result, strings.Split(scanner.Text(), ","))
		i++
	}

	return result
}

// Reflect the upper triangle of a square matrix over the diagonal
func Reflect(m [][]string) {
	rows := len(m)
	cols := len(m[0])
	for i := 0; i < rows; i++ {
		for j := i + 1; j < cols; j++ {
			m[j][i] = m[i][j]
		}
	}
}

func toDelimited(m [][]string, delimeter string) {
	for _, row := range m {
		fmt.Println(strings.Join(row, delimeter))
	}
}

// GenProblems generates all walks with length
// this code is garbage
func GenProblems(m string, problem []string, moves map[string]map[string]int) {

	// no repeated positions
	if in(m, problem) {
		return
	}

	numPos := len(problem)

	// check that there are no repeated holds in any of the moves
	// prior to the latest move
	for i := 0; i < numPos-1; i++ {
		if strings.ContainsAny(problem[i], m) {
			return
		}
	}

	problem = append(problem, m)
	numPos++
	// n positions corresponds to n-1 edges
	numMoves := numPos - 1

	// keep going
	if numMoves < MoveCount {

		if numMoves < 2 {
			for k := range moves[m] {
				GenProblems(k, problem, moves)
			}
		} else {
			for i := 0; i < 2; i++ {
				k := randomKey(moves[m])
				GenProblems(k, problem, moves)
			}
		}
	}

	if numMoves == MoveCount {
		fmt.Println(strings.Join(problem, ","))
	}

}

func in(v string, arr []string) bool {
	for _, a := range arr {
		if a == v {
			return true
		}
	}
	return false
}

// returns a random key from the map
func randomKey(m map[string]int) string {
	x := rand.Intn(len(m))
	// range through the map keys x times
	// a reasonable way to get random map keys
	for k := range m {
		if x == 0 {
			return k
		}
		x--
	}
	return ""
}
