# We need to replace the 'id' column values by 'DEFAULT' which will ensure
# correct (non-conflicting) values are generated on the superhub.
/^INSERT INTO public."\?__promiselog/s/VALUES [^,]*,/VALUES (DEFAULT,/;
