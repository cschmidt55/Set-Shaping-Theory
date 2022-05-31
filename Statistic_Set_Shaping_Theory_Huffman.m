%                 Statistics_Set_Shaping_Theory_Huffman
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The program performs the following operations:
% 1) generates a random sequence with uniform distribution
% 2) calculate the frequencies of the symbols present in the sequence 
% 3) use this information to calculate the total information content sequence
% 4) apply the transform 
% 5) code the transformed sequence
% 6) compares the total information content of the generated sequence 
%    with the length of the encoded transfromated sequence
% 7) repeats all these steps a number of times defined by the parameter history
% 8) display the average values obtained
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          important
%
% If you change the length of the sequence and the number of the generated 
% symbols, you have to be careful that the huffman encoding approximates the 
% information content of the sequence by about one bit. if you take too 
% long sequences the huffman algorithm becomes very inefficient therefore, 
% it cannot detect the advantage obtained by the transformation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
history=100;
ns=10;
len=20;
cs=0;
totcodel=0;
totinfc=0;
tottinfc=0;
itnent=0;
infc=0;
tinfc=0;
itinfc=0;

for i=1:history
   
 index=0;

 % Genaration of the sequence with a uniform distribution

 symbols=1:ns;
 prob(1,1:ns)=1/ns;
 seq=randsrc(1,len,[symbols; prob]);

 % Total information content sequence

 infc=0;

 for i=1:len

  sy=seq(1,i);
  fs=nnz(seq==sy)/len;
  infc=infc-log2(fs);

 end

% Start trasformation

 mcodel=10000;
 
 for t=1:ns  


  index=0;

% In the last position of the new sequence we put the parameter of the function
% Therefore having chosen to generate 10 symbols (ns=10) this parameter can assume ten different values so we get ten transformed sequences.

  nlen=len+1;
  nseq(1,nlen)=t;

% We use the parameter t in order to initialize the randsrc function and obtain a vector of length len with a uniform distribution

  ran=randsrc(1,len,[symbols; prob],t);

% We apply the transform 
% The function used is mod(seq(1,i2)+ran(i2),ns)+1 

  for i2=1:len

   rseq=mod(seq(1,i2)+ran(i2),ns)+1;
   nseq(1,i2)=rseq;

  end 

% total information content of the transformed sequence of length nlen=len+1

  tinfc=0;

  for i=1:nlen

   sy=nseq(1,i);
   fs=nnz(nseq==sy)/nlen;
   tinfc=tinfc-log2(fs);

  end 

  nseq;

 % Having transformed the sequence we have to redefine the length of the vectors that are used in the encoding

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

  rent=0;

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

  dict=huffmandict(vs,counts);
  code=huffmanenco(nseq,dict);
  seqd=huffmandeco(code,dict);

  bcode=de2bi(code);
  codel=numel(bcode);

 % We save the transformed sequence with the shortest encoding

  if codel < mcodel

   mcodel=codel;
   mseq=nseq;
   mcode=code;
   mdict=dict;
   mtinfc=tinfc;

  end

 end

% If the length of the encoded message of the transformed sequence is less than the information content of the original sequence, we increase the counter cs by one

 if mcodel < infc

  cs=cs+1;

 end

 totcodel=totcodel+mcodel;
 totinfc=totinfc+infc;
 tottinfc=tottinfc+mtinfc;

end

% We calculate the average of the information content of the generated sequences,the average of the information content of the transformed sequences and the average of the length of the encoded transformed sequence
  
 medinfc=totinfc/history;
 medcodel=totcodel/history;
 medtinfc=tottinfc/history;

% We calculate the percentage of sequences where the length of the encoded transformed sequence is less than the total information content of the generated sequence

 pcs=(cs/history)*100;

% We display the average values obtained

 fprintf('The average of the information content of the generated sequences\n');
 medinfc

 fprintf('The average of the length of the encoded transformed sequence\n');
 medcodel

 fprintf('The average of the information content of the transformed sequences\n');
 medtinfc

 fprintf('Number of sequences where the length of the encoded transformed sequence is less than the total information content of the generated sequence\n');
 cs

 fprintf('There is a percentage of %2.0f%% that length of the encoded transformed sequence is less than the total information content of the generated sequence\n',pcs);

