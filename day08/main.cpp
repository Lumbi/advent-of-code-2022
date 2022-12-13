#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>

using namespace std;

typedef vector<int> Row;
typedef vector<Row> Grid;

const int VISIBLE = 1;
const int UNKNOWN = 0;

ostream& operator<<(ostream& os, const Grid& grid)
{
    for (auto &row : grid)
    {
        for (auto &character : row)
        {
            os << character;
        }
        os << endl;
    }
    return os;
}

int main()
{
    // Load grid

    Grid height_grid;
    Grid visibility_grid;

    ifstream input_stream;
    input_stream.open("input.txt");

    string line;
    while (getline(input_stream, line))
    {
        Row height_row;
        Row visibility_row;
        for (auto &character : line)
        {
            int height = int(character - '0');
            height_row.push_back(height);
            visibility_row.push_back(UNKNOWN);
        }
        height_grid.push_back(height_row);
        visibility_grid.push_back(visibility_row);
    }

    input_stream.close();

    // Compute visibility

    const int ROW_COUNT = height_grid.size();
    const int COLUMN_COUNT = height_grid[0].size();

    for (int row = 0; row < ROW_COUNT; row++)
    {
        for (int column = 0; column < COLUMN_COUNT; column++)
        {
            // Set visible if at the edge
            if (row == 0 || column == 0 || row == ROW_COUNT-1 || column == COLUMN_COUNT-1)
            {
                visibility_grid[column][row] = VISIBLE;
                continue;
            }

            const int this_height = height_grid[row][column];
            const int this_visibility = visibility_grid[row][column];

            int visibility = VISIBLE; // Assume visible

            // Visibility from the top
            visibility = VISIBLE;
            for (int top = 0; top < row; top++) { visibility = visibility && this_height > height_grid[top][column]; }
            visibility_grid[row][column] = visibility;
            if (visibility == VISIBLE) { continue; }

            // Visibility from the bottom
            visibility = VISIBLE;
            for (int bottom = row+1; bottom < ROW_COUNT; bottom++) { visibility = visibility && this_height > height_grid[bottom][column]; }
            visibility_grid[row][column] = visibility;
            if (visibility == VISIBLE) { continue; }

            // Visibility from the left
            visibility = VISIBLE;
            for (int left = 0; left < column; left++) { visibility = visibility && this_height > height_grid[row][left]; }
            visibility_grid[row][column] = visibility;
            if (visibility == VISIBLE) { continue; }

            // Visibility from the right
            visibility = VISIBLE;
            for (int right = column+1; right < COLUMN_COUNT; right++) { visibility = visibility && this_height > height_grid[row][right]; }
            visibility_grid[row][column] = visibility;
        }
    }

    // Count visible

    int visible_count = 0;
    for (int row = 0; row < ROW_COUNT; row++)
    {
        for (int column = 0; column < COLUMN_COUNT; column++)
        {
            if (visibility_grid[row][column] == VISIBLE) { visible_count++; }
        }
    }

    cout << "star 1: " << visible_count << endl;

    // Calculate scenic scores

    vector<int> scenic_scores;

    for (int row = 0; row < ROW_COUNT; row++)
    {
        for (int column = 0; column < COLUMN_COUNT; column++)
        {
            const int this_height = height_grid[row][column];

            // Looking top
            int view_distance_top = 0;
            if (row > 0)
            {
                for (int top = row-1; top >= 0; top--)
                {
                    view_distance_top++;
                    if (height_grid[top][column] >= this_height) { break; }
                }
            }

            // Looking bottom
            int view_distance_bottom = 0;
            if (row < ROW_COUNT)
            {
                for (int bottom = row+1; bottom < ROW_COUNT; bottom++)
                {
                    view_distance_bottom++;
                    if (height_grid[bottom][column] >= this_height) { break; }
                }
            }

            // Looking left
            int view_distance_left = 0;
            if (column > 0)
            {
                for (int left = column-1; left >= 0; left--)
                {
                    view_distance_left++;
                    if (height_grid[row][left] >= this_height) { break; }
                }
            }

            // Looking right
            int view_distance_right = 0;
            if (column < COLUMN_COUNT)
            {
                for (int right = column+1; right < COLUMN_COUNT; right++)
                {
                    view_distance_right++;
                    if (height_grid[row][right] >= this_height) { break; }
                }
            }

            int scenic_score = view_distance_top * view_distance_bottom * view_distance_left * view_distance_right;
            scenic_scores.push_back(scenic_score);
        }
    }

    int max_scenic_score = *max_element(scenic_scores.begin(), scenic_scores.end());

    cout << "star 2: " << max_scenic_score << endl;
}
