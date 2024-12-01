use context starter2024

include file("puzzle-data.arr")
include string-dict




  

# Read the lines of the file and produce a pair from each line
fun read-file(file :: String):
  string-split-all(file, "\n").map(lam(x): string-split(x, " ") end)
end

lines = read-file(puzzle-data)

# Converts the pair to numbers and make two list from the pair


arr1 = lines.map(lam(x): string-to-number(x.get(0)) end)
arr2 = lines.map(lam(x): string-to-number(x.get(1)) end)

# extract the numbers 
arr-list1 = map(lam(x): x.or-else(0) end, arr1)
arr-list2 = map(lam(x): x.or-else(0) end, arr2)


# check:
  
#   compute-total-distance(arr-list1, arr-list2) is 11
#   similarity-score(arr-list1, arr-list2) is 31
# end




fun compute-total-distance(lst1 :: List<Number>, lst2 :: List<Number>) -> Number:
  doc: "Computes sum of the distance between the two lists in ascending order"
  
  if lst1.length() <> lst2.length():
    raise("The lists must have the same length")
  else:
    fold2(lam(acc, x, y): acc + num-abs(x - y) end, 0, lst1.sort(), lst2.sort())
  end
  
where:
  compute-total-distance([list:1, 2], [list:1]) raises ""
  compute-total-distance([list:3, 4, 2, 1, 3, 3], [list: 4, 3, 5, 3, 9, 3]) is 11
end





fun similarity-score(list1 :: List<Number>, list2 :: List<Number>) -> Number:
  doc: "Compute the similarity score by mulitplying the number in the first list by the number of times it appears int the second list and add all the scores"
  
  
  fun helper(seen :: StringDict, l1 :: List<Number>, l2 :: List<Number>, acc :: Number) -> Number:
    doc: "helper function to compute running similarity score"
    
    cases (List) l1:
      | empty => acc
      | link(f, r) =>
        
        if (seen.has-key(num-to-string(f))):
          helper(seen, r, l2, acc + seen.get-value(num-to-string(f)))
        else:
          freq = l2.filter(lam(x): x == f end).length()
          score = f * freq
          new-seen = seen.set(num-to-string(f), score)
          helper(new-seen, r, l2, acc + score)
        end
    end
        
  end
  
  
  helper([string-dict: ], list1, list2, 0)
  
  
where:
  similarity-score([list:3, 4, 2, 1, 3, 3], [list: 4, 3, 5, 3, 9, 3]) is 31
 
  
end



