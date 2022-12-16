package main

import (
	"fmt"
	"os"
	"strings"
	"strconv"
)

type point struct {
    x int
    y int
}

// I can't believe I have to implement this myself
func abs(x int) int {
	if x >= 0 {
		return x
	} else {
		return 0 - x
	}
}

func distance(a point, b point) int {
	return abs(b.x - a.x) + abs(b.y - a.y)
}

func main() {
	data, _ := os.ReadFile("input.txt")
	input := string(data)

	world := make(map[point]byte)

	lines := strings.Split(input, "\n")

	var sensor_ps []point
	var beacon_ps []point

	for _, line := range lines {
		string_pairs := strings.Split(line[10:], ": closest beacon is at ")

		sensor_x, _ := strconv.Atoi(strings.Split(string_pairs[0], ", ")[0][2:])
		sensor_y, _ := strconv.Atoi(strings.Split(string_pairs[0], ", ")[1][2:])
		beacon_x, _ := strconv.Atoi(strings.Split(string_pairs[1], ", ")[0][2:])
		beacon_y, _ := strconv.Atoi(strings.Split(string_pairs[1], ", ")[1][2:])

		sensor_p := point{ x: sensor_x, y: sensor_y }
		beacon_p := point{ x: beacon_x, y: beacon_y }

		world[sensor_p] = 'S'
		world[beacon_p] = 'B'

		sensor_ps = append(sensor_ps, sensor_p)
		beacon_ps = append(beacon_ps, beacon_p)
	}

	target_y := 2000000

	for i, _ := range sensor_ps {
		sensor_p := sensor_ps[i]
		beacon_p := beacon_ps[i]
		radius := distance(sensor_p, beacon_p)
		sensor_x := sensor_p.x
		sensor_y := sensor_p.y

		within_range := (sensor_y <= target_y && sensor_y + radius >= target_y) || (sensor_y >= target_y && sensor_y - radius <= target_y)

		if within_range {
			dist_to_target := abs(sensor_y - target_y)

			overlap := radius - dist_to_target
			start_x := sensor_x - overlap
			end_x := sensor_x + overlap

			for x := start_x; x <= end_x; x++ {
				p := point{ x: x, y: target_y }
				_, ok := world[p]
				if ok {
					// derp
				} else {
					world[p] = '#'
				}
			}
		}
	}

	count := 0
	for k, v := range world {
		if k.y == target_y && v == '#' {
			count++
		}
	}

	fmt.Println("star1:", count)

	world_max := 4000000
	is_within_range := func(p point) bool {
		if !(p.x >= 0 && p.y >= 0 && p.x <= world_max && p.y <= world_max) {
			return true // ignore point
		}

		_, ok := world[p]
		if ok { // occupied
			return true // ignore point
		}

		for i, sensor_p := range sensor_ps {
			beacon_p := beacon_ps[i]
			radius := distance(sensor_p, beacon_p)
			dist := distance(p, sensor_p)
			if dist <= radius {
				return true
			}
		}
		return false // lone point
	}

	found_lone_point := false
	lone_point := point{ x: 0, y: 0 }
	for i, sensor_p := range sensor_ps {
		beacon_p := beacon_ps[i]
		radius := distance(sensor_p, beacon_p)

		sensor_x := sensor_p.x
		start_x := sensor_x - radius + 1
		end_x := sensor_x + radius + 1

		for x := start_x; x <= end_x; x++ {
			dx := abs(sensor_x - x)
			dy := (radius + 1 - dx)
			if dy == 0 {
				side := point{ x: x, y: sensor_p.y }
				if !is_within_range(side) {
					lone_point = side
					found_lone_point = true
					break
				}
			} else {
				up := point{ x: x, y: sensor_p.y - dy }
				down := point{ x: x, y: sensor_p.y + dy }

				if !is_within_range(up) {
					lone_point = up
					found_lone_point = true
					break
				}

				if !is_within_range(down) {
					lone_point = up
					found_lone_point = true
					break
				}
			}
		}

		if found_lone_point {
			break
		}
	}

	fmt.Println("star2:", lone_point, lone_point.x * 4000000 + lone_point.y)
}
