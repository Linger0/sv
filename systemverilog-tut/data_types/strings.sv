// module tb;
//   string firstname = "Joey";
//   string lastname = "Tribbiani";

//   initial begin
//     if (firstname == lastname)
//       $display("firstname=%s is EQUAL to lastname=%s", firstname, lastname);

//     if (firstname != lastname)
//       $display("firstname=%s is NOT EQUAL to lastname=%s", firstname, lastname);

//     if (firstname < lastname)
//       $display("firstname=%s is LESS THAN to lastname=%s", firstname, lastname);

//     if (firstname > lastname)
//       $display("firstname=%s is GREATER THAN to lastname=%s", firstname, lastname);

//     $display("Full Name = %s", {firstname, " ", lastname});

//     $display("%s", {3{firstname}});

//     $display("firstname[2]=%s, lastname[2]=%s", firstname[2], lastname[2]);

//   end
// endmodule

module tb;
  string str = "Hello World!";

  initial begin
    string tmp;

    $display("str.len() = %0d", str.len());

    tmp = str;
    tmp.putc(3, "d");
    $display("str.putc(3, d) = %s", tmp);

    $display("str.getc(2) = %s (%0d)", str.getc(2), str.getc(2));

    $display("str.tolower() = %s", str.tolower());

    tmp = "Hello World!";
    $display("[tmp,str are same] str.compare(tmp) = %0d", str.compare(tmp));
    tmp = "How are you?";
    $display("[tmp,str are diff] str.compare(tmp) = %0d", str.compare(tmp));

    tmp = "hello world!";
    $display("[tmp is in lowercase] str.compare(tmp) = %0d", str.compare(tmp));
    tmp = "Hello World!";
    $display("[tmp,str are same] str.compare(tmp) = %0d", str.compare(tmp));

    $display("str.substr(4,8) = %s", str.substr(4,8));
  end
endmodule