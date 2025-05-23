package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	if len(os.Args) != 3 {
		fmt.Println("Usage: url2html <inputfile> <outputfile>")
		return
	}

	inputPath := os.Args[1]
	outputPath := os.Args[2]

	// Open the input file
	inputFile, err := os.Open(inputPath)
	if err != nil {
		fmt.Println("Error opening input file:", err)
		return
	}
	defer inputFile.Close()

	// Create the output file
	outputFile, err := os.Create(outputPath)
	if err != nil {
		fmt.Println("Error creating output file:", err)
		return
	}
	defer outputFile.Close()

	// Write HTML header
	outputFile.WriteString("<!DOCTYPE html>\n<html>\n<head><title>URL List</title></head>\n<body>\n")

	// Write each URL as a link
	scanner := bufio.NewScanner(inputFile)
	for scanner.Scan() {
		url := scanner.Text()
		if url != "" {
			outputFile.WriteString(fmt.Sprintf("<a href=\"%s\" target=\"_blank\">%s</a><br>\n", url, url))
		}
	}

	// Write HTML footer
	outputFile.WriteString("</body>\n</html>\n")

	fmt.Printf("HTML file '%s' generated successfully.\n", outputPath)
}
