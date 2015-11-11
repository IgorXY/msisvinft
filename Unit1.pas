unit Unit1;

interface

uses
   Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
   System.Classes, Vcl.Graphics,
   Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
   TForm1 = class(TForm)
      OpenDialog1: TOpenDialog;
      Button1: TButton;
      Button2: TButton;
      Memo1: TMemo;
      Label1: TLabel;
      procedure Button1Click(Sender: TObject);
      procedure Button2Click(Sender: TObject);
      procedure FormCreate(Sender: TObject);
   private
      { Private declarations }
   public
      { Public declarations }
   end;

const
   length1: integer = 1;
   length2: integer = 2;
   length3: integer = 3;
   length4: integer = 4;
   length5: integer = 5;
   length6: integer = 6;
   length7: integer = 7;
   length8: integer = 8;

var
   Form1: TForm1;
   code: string;
   count_of_if, count_of_operators: integer;
   operator_length_1: array [1 .. 13] of string;
   operator_length_2: array [1 .. 16] of string;
   operator_length_3: array [1 .. 3] of string;
   operator_length_4: array [1 .. 1] of string;
   operator_length_5: array [1 .. 2] of string;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
   f: textfile;
   string_buf: string;
   ch: char;
   ternanl_operator, long_comment: boolean;
   i, j, k: integer;
begin
   count_of_if := 0;
   count_of_operators := 0;
   if OpenDialog1.Execute then
   begin
      code := '';
      string_buf := '';
      long_comment := false;
      AssignFile(f, OpenDialog1.FileName);
      reset(f);
      if not eof(f) then
         while not eof(f) do
         begin
            readln(f, string_buf);
            if copy(string_buf, 1, 6) = '=begin' then
               long_comment := true;
            if not long_comment then
            begin
               j := 0;
               k := 0;
               ternanl_operator := false;
               for i := 1 to length(string_buf) do
               begin
                  if string_buf[i] = '#' then
                     j := i;
                  if string_buf[i] = '?' then
                     k := i;
                  if (string_buf[i] = ':') and (k <> 0) then
                     ternanl_operator := true;
               end;
               if ternanl_operator then
                  string_buf := copy(string_buf, 1, k - 1) + ' if ' +
                    copy(string_buf, k + 1, length(string_buf));
               if j > 0 then
                  delete(string_buf, j, length(string_buf) - j);
               code := code + ' ' + string_buf + ' ';
            end;
            if copy(string_buf, 1, 4) = '=end' then
               long_comment := false;
         end
      else
         ShowMessage('File is empty!');
   end
   else
      ShowMessage('Error file !');
   // Memo1.Text := s;
end;

function IsOperatorLength1(test_string: string): boolean;
var
   i: integer;
   bool_result: boolean;
begin
   bool_result := false;
   for i := 1 to length(operator_length_1) do
      if test_string = operator_length_1[i] then
         bool_result := true;
   IsOperatorLength1 := bool_result;
end;

function IsOperatorLength2(test_string: string): boolean;
var
   i: integer;
   bool_result: boolean;
begin
   bool_result := false;
   for i := 1 to length(operator_length_2) do
      if test_string = operator_length_2[i] then
         bool_result := true;
   IsOperatorLength2 := bool_result;
end;

function IsOperatorLength3(test_string: string): boolean;
var
   i: integer;
   bool_result: boolean;
begin
   bool_result := false;
   for i := 1 to length(operator_length_3) do
      if test_string = operator_length_3[i] then
         bool_result := true;
   IsOperatorLength3 := bool_result;
end;

function IsOperatorLength4(test_string: string): boolean;
var
   i: integer;
   bool_result: boolean;
begin
   bool_result := false;
   for i := 1 to length(operator_length_4) do
      if test_string = operator_length_4[i] then
         bool_result := true;
   IsOperatorLength4 := bool_result;
end;

function IsOperatorLength5(test_string: string): boolean;
var
   i: integer;
   bool_result: boolean;
begin
   bool_result := false;
   for i := 1 to length(operator_length_5) do
      if test_string = operator_length_5[i] then
         bool_result := true;
   IsOperatorLength5 := bool_result;
   // Form1.Memo1.Lines.Add(s);
end;

procedure CheckString(test_string, compare_string: string;
  var nest, count_if: integer);
begin
   if test_string = compare_string then
   begin
      inc(nest);
      inc(count_if);
   end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
   i: integer;
   nest, max_nest: integer;
begin
   Memo1.Text := '';
   nest := 0;
   max_nest := 0;
   for i := 1 to length(code) do
   begin
      CheckString(copy(code, i, length(' if ')), ' if ', nest, count_of_if);
      CheckString(copy(code, i, length(' elsif ')), ' elsif ', nest,
        count_of_if);
      CheckString(copy(code, i, length(' when ')), ' when ', nest, count_of_if);
      CheckString(copy(code, i, length(' unless ')), ' unless ', nest,
        count_of_if);
      if copy(code, i, length(' end ')) = ' end ' then
      begin
         if (nest > max_nest) then
            max_nest := nest;
         nest := 0;
      end;
   end;
   i := 1;
   while i < length(code) do
   begin
      if IsOperatorLength5(copy(code, i, length5)) then
      begin
         inc(count_of_operators);
         i := i + length4;
      end
      else
         if IsOperatorLength4(copy(code, i, length4)) then
         begin
            inc(count_of_operators);
            i := i + length3;
         end
         else
            if IsOperatorLength3(copy(code, i, length3)) then
            begin
               inc(count_of_operators);
               i := i + length2;
            end
            else
               if IsOperatorLength2(copy(code, i, length2)) then
               begin
                  inc(count_of_operators);
                  i := i + length1;
               end
               else
                  if IsOperatorLength1(copy(code, i, length1)) then
                  begin
                     inc(count_of_operators);
                  end;
      i := i + length1;
   end;

   count_of_operators := count_of_operators + count_of_if;
   Memo1.Lines.Add('Количество операторов условия: ' + IntToStr(count_of_if));
   Memo1.Lines.Add('Макс вложенность операторов условия: ' +
     IntToStr(max_nest));
   Memo1.Lines.Add('Количество операторов: ' + IntToStr(count_of_operators));
   Memo1.Lines.Add('Отношение: ' + FloatToStr(count_of_if /
     count_of_operators));

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   operator_length_1[1] := '=';
   operator_length_1[2] := '+';
   operator_length_1[3] := '-';
   operator_length_1[4] := '*';
   operator_length_1[5] := '/';
   operator_length_1[6] := '>';
   operator_length_1[7] := '<';
   operator_length_1[8] := '&';
   operator_length_1[9] := '|';
   operator_length_1[10] := '!';
   operator_length_1[11] := '~';
   operator_length_1[12] := '^';
   operator_length_1[13] := '%';

   operator_length_2[1] := '==';
   operator_length_2[2] := '+=';
   operator_length_2[3] := '-=';
   operator_length_2[4] := '**';
   operator_length_2[5] := '/=';
   operator_length_2[6] := '>>';
   operator_length_2[7] := '<<';
   operator_length_2[8] := '&&';
   operator_length_2[9] := '||';
   operator_length_2[10] := '!=';
   operator_length_2[11] := '..';
   operator_length_2[12] := '::';
   operator_length_2[13] := '%=';
   operator_length_2[14] := '>=';
   operator_length_2[15] := '<=';
   operator_length_2[16] := '<<';

   operator_length_3[1] := '===';
   operator_length_3[2] := '<=>';
   operator_length_3[3] := '**=';

   operator_length_4[1] := ' or ';

   operator_length_5[1] := ' and ';
   operator_length_5[2] := ' not ';
end;

end.
