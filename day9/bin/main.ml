(* COMMON *)

type position = { x: int; y: int };;

let zero = { x = 0; y = 0 };;

let rec repeat a count =
  match count with
    | 0 -> []
    | 1 -> [a]
    | _ -> a :: repeat a (count - 1)
;;

let rec drop_duplicates list =
  match list with
    | [] -> list
    | first :: rest ->
      if List.mem first rest then drop_duplicates rest
      else first :: drop_duplicates rest
;;

let rec parse_lines lines input_file =
  match input_line input_file with
    | exception End_of_file -> []
    | line ->
      let parts = String.split_on_char ' ' line in
      let direction = List.nth parts 0 in
      let count = int_of_string (List.nth parts 1) in
      (repeat direction count) @ parse_lines lines input_file
;;

let move_head head direction =
  match direction with
    | "R" -> { x = head.x + 1; y = head.y }
    | "U" -> { x = head.x; y = head.y + 1 }
    | "L" -> { x = head.x - 1; y = head.y }
    | "D" -> { x = head.x; y = head.y - 1 }
    | _ -> failwith "Invalid direction"
;;

let move_tail_to_head tail head =
    let dx = head.x - tail.x in
    let dy = head.y - tail.y in
    if (abs dx) <= 1 && (abs dy) <= 1 then tail (* tail doesn't move  *)
    else match (dx, dy) with (* tail moves by one *)
      | (_, 0) -> { x = tail.x + (dx / abs dx); y = tail.y }
      | (0, _) -> { x = tail.x; y = tail.y + (dy / abs dy) }
      | (_, _) -> { x = tail.x + (dx / abs dx); y = tail.y + (dy / abs dy) }
;;

(* STAR 1 *)

let rec positions_visited_by_tail head tail visited steps =
  match steps with
    | [] -> visited
    | direction :: rest ->
      let new_head = move_head head direction in
      let new_tail = move_tail_to_head tail new_head in
      positions_visited_by_tail new_head new_tail (new_tail :: visited) rest
;;

let star1 =
    let input_file = open_in "input.txt" in
    let steps = parse_lines [] input_file in
    let visited = List.rev (positions_visited_by_tail zero zero [zero] steps) in
    List.length (drop_duplicates visited)
;;

(* STAR 2 *)

let rec move_rope_to_head head rope =
  match rope with
    | [] -> rope
    | first :: rest ->
      let moved_first = move_tail_to_head first head in
      moved_first :: (move_rope_to_head moved_first rest)
;;

let rec positions_visited_by_tail_of_rope head rope visited steps =
  match steps with
    | [] -> visited
    | direction :: rest ->
      let new_head = move_head head direction in
      let new_rope = move_rope_to_head new_head rope in
      let new_tail = List.hd (List.rev new_rope) in
      positions_visited_by_tail_of_rope new_head new_rope (new_tail :: visited) rest
;;

let star2 =
  let input_file = open_in "input.txt" in
  let steps = parse_lines [] input_file in
  let visited = List.rev (positions_visited_by_tail_of_rope zero (repeat zero 9) [zero] steps) in
  List.length (drop_duplicates visited)
;;

(* ANSWER *)

let () = Printf.printf "star 1: %d\nstar2: %d\n" star1 star2;
