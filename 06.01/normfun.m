function out=normfun(in,num)
Min=min(min(in));
Max=max(max(in));
out=num*(in-Min)/(Max-Min);
m_r=find(out>num);
out(m_r)=num;
n_r=find(out<0);
out(n_r)=0;