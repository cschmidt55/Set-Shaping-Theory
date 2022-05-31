%                     Set_Shaping_Theory_Huffman
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The program performs the following operations:
% 1) generates a random sequence with uniform distribution
% 2) calculate the frequencies of the symbols present in the sequence 
% 3) use this information to calculate the total information content sequence
% 4) encode the sequence using the huffman encoding (using the calculate frequencies)
% 5) apply the transform 
% 6) code the transformed sequence
% 7) we send to the decoder the encoded transformed sequence and the dictionary  
% 8) apply the inverse transform to obtain the initial sequence
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          important
%
% If you change the length of the sequence and the number of the generated 
% symbols, you have to be careful that the huffman encoding approximates the 
% information content of the sequence by about one bit. if you take too 
% long sequences the Huffman algorithm becomes very inefficient therefore, 
% it cannot detect the advantage obtained by the transformation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          important
%
% When the number of symbols is 10 and the length of the message is 20, 
% this method allows decoding the message with a number of bits less than 
% the information content of the sequence about 65% of the time.
% Therefore this program is used to understand how this method works 
% for a statistical analysis to use the program "Statistic_Set_Shaping_Theory_Huffman"  
% in which 10 thousand sequences a are generated and encoded. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
ns=10;
len=20;
mcodel=10000;
infc=0;
index=0;

% Genaration of the sequence with a uniform distribution

symbols=1:ns;
prob(1,1:ns)=1/ns;
seq=randsrc(1,len,[symbols; prob]);

fprintf('Initial sequence');

seq

% Total information content sequence

for i=1:len

 sy=seq(1,i);
 fs=nnz(seq==sy)/len;
 infc=infc-log2(fs);

end 

fprintf('Total information content sequence. %4.2f bit \n\n',infc);

% Coding the sequence

fprintf('We calculate the frequencies of the symbols present in the sequence and we encode it using the huffman encoding. \n');

for i=1:ns

 fs=nnz(seq==i)/len;

  if fs > 0

   index=index+1;    
   c(index)=fs;  
   vs(index)=i;

  end

end 

counts=[c];

idict=huffmandict(vs,counts);
icode=huffmanenco(seq,idict);

bcode=de2bi(icode);
icodel=numel(bcode);

fprintf('List of the codeword \n');
idict

fprintf('Encoded message\n');
icode;

fprintf('Length of the encoded message %4.2f bit \n\n', icodel);

% Start trasformation

fprintf('We apply the transformation. \n');
fprintf('The length of the message increases by one because the parameter used in the transform is inserted in the last position.\n');
fprintf('The number of symbols emitted%3.0f therefore this parameter can assume%3.0f different values, so we get%3.0f transformed sequences.\n\n',ns,ns,ns);

for t=1:ns  

 index=0;

% In the last position of the new sequence we put the parameter of the function
% Therefore having chosen to generate 10 symbols (ns=10) this parameter can assume ten different values so we get ten transformed sequences.

 nseq(1,len+1)=t;

% We use the parameter t in order to initialize the randsrc function and obtain a vector of length len with a uniform distribution

 ran=randsrc(1,len,[symbols; prob],t);

% We apply the transform 
% The function used is mod(seq(1,i2)+ran(i2),ns)+1 

 for i2=1:len

  rseq=mod(seq(1,i2)+ran(i2),ns)+1;
  nseq(1,i2)=rseq;

 end

% The new sequence is long nlen=len+1, because in the last position we have added the parameter of the function
 
 nlen=len+1;

% Having transformed the sequence, we have to redefine the length of the vectors that are used in the encoding

 index=0;

 for i2=1:ns

  fs=nnz(nseq==i2)/nlen;

  if fs > 0

   index=index+1;    

  end

 end 

 c=zeros(index,1);
 vs=zeros(index,1);
 index=0;

 % We calculate the frequencies of the symbols in the transformed sequence

 for i2=1:ns

  fs=nnz(nseq==i2)/nlen;

  if fs > 0

   index=index+1;    
   c(index)=nnz(nseq==i2)/nlen;  
   vs(index)=i2;

  end

 end 

 % We code the transformed sequence

 counts=[c];

 tdict=huffmandict(vs,counts);
 tcode=huffmanenco(nseq,tdict);

 bcode=de2bi(tcode);
 tcodel=numel(bcode);

 % We save the transformed sequence with the shortest encoding

 if tcodel < mcodel

  mcodel=tcodel;
  mseq=nseq;
  mcode=tcode;
  mdict=tdict;

 end

end

fprintf('Transformed sequence with the shortest encoding \n');
mseq

fprintf('We report the huffman encoding data relating to the sequence with the shortest encoding length \n');

fprintf('List of the codeword \n');
mdict

fprintf('Encoded message\n');
mcode;

fprintf('Length of the encoded message %4.2f bit \n\n', mcodel);

fprintf('We send the encoded message and the list of codewords to the decoder\n\n');

% Decoding
% To the decoder we send the coded sequence mcode and the dictionary mdict (list of the codewords)

mseqd=huffmandeco(mcode,mdict);

fprintf('We decode the message and get the transformed sequence\n\n');
mseqd

% We read the first value of the sequence which represents the parameter necessary to apply the inverse transform

pr=mseqd(1,len+1);

% We apply the inverse transform and we obtain the initial sequence

ran=randsrc(1,len,[symbols; prob],pr);
index=0;

for i=1:len
    
 rs=mseqd(1,i)-1;
 iv=mod(rs-ran(i),ns);

 if iv == 0

  iv=ns;

 end

 iseq(1,i)=iv;

end

fprintf('we read the last value of the transformed sequence which tells us which of the ten transformed \nsequences is the one with the shortest encoding length.\n\n');
fprintf('we apply the inverse transform to obtain the initial sequence \n\n');

iseq


