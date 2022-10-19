module tb;
  int fd;
  int idx;
  string line;

  initial begin
    fd = $fopen("tmp/trial", "w");
    for (int i = 0; i < 3; i++) begin
      $fdisplay(fd, "Iteration=%0d", i);
    end
    $fclose(fd);

    fd = $fopen("tmp/trial", "r");
    while ($fscanf(fd, "%s=%d", line, idx) == 2) begin
      $display("Line: %s=%d", line, idx);
    end
    // while (!$feof(fd)) begin
    //   $fgets(line, fd);
    //   $display("Line: %s", line);
    // end

    $fclose(fd);
  end
endmodule
