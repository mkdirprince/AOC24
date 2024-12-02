use context starter2024

include file("sample-data.arr")

fun process-file(file :: String)-> List<List<Number>>:
  doc: "read file and process the content to produce a list of list of numbers"
  string-split-all(file, "\n").map(lam(x): string-split-all(x, " ").map(lam(y): string-to-number(y).or-else(0) end) end)
end


check:
  report-lists = process-file(sample-input)

  report-safe(report-lists, is-safe, 0) is 2
  report-safe(report-lists, is-tolerant-safe, 0) is 4
end


fun report-safe<T>(report-lists :: List<List<T>>, safe-function :: (T -> Boolean), acc :: T) -> T:
  doc: "consumes a list of reports, a safe function and accumulator and return the number of safe reports based on the safe function"

  cases(List) report-lists:
    | empty => acc
    | link(f, r) =>
      if safe-function(f):
        report-safe(r, safe-function, acc + 1)
      else:
        report-safe(r, safe-function, acc)
      end
  end
  
where:
  report-safe([list: [list:7, 6, 4, 2, 1], [list: 1, 2, 7, 8, 9], [list: 9, 7, 6, 2, 1], [list: 1, 3, 2, 4, 5], [list: 8, 6, 4, 4, 1],[list: 1, 3, 6, 7, 9]], is-tolerant-safe, 0) is 4
  
  report-safe([list: [list:7, 6, 4, 2, 1], [list: 1, 2, 7, 8, 9], [list: 9, 7, 6, 2, 1], [list: 1, 3, 2, 4, 5], [list: 8, 6, 4, 4, 1],[list: 1, 3, 6, 7, 9]], is-safe, 0) is 2
end



fun is-tolerant-safe(lst :: List<Number>) -> Boolean:
  doc: "process a list and determine if it is safe. This is a variant of is-safe and tolerate a single bad level"
  
  
  # Helper function to remove each element once and checking if the resulting list is safe
  fun helper(seen, n-lst):
    cases (List) n-lst:
      | empty => false
      | link(f, r) =>
        if is-safe(seen.append(r)):
          true
        else:
          new-seen = seen.append([list: f])
          helper(new-seen, r)
        end
    end
  end


  if is-safe(lst):
    true
  else:
    helper(empty, lst)
  end

where:
  is-tolerant-safe([list: 1, 3, 2, 4, 5]) is true
  is-tolerant-safe([list: 8, 6, 4, 4, 1]) is true
  is-tolerant-safe([list: 91, 91, 93, 93, 95, 96, 99]) is false
  
end


fun is-safe(lst :: List<Number>) -> Boolean:
  doc: "process a list and determine if it is safe. A list is safe if  either all the numbers are increasing or decreasing and if two adjacent levels differe by at least one and at most three"

  fun helper(num-lst, prev):

    cases (List) num-lst:
      | empty => true
      | link(f, r) => 
        if (num-abs(f - prev) >= 1) and (num-abs(f - prev) <= 3):
          helper(r, f)
        else:
          false
        end
    end
  end

  if is-sorted(lst):
    helper(lst.rest, lst.first)
  else:
    false
  end

where:
  is-safe([list: 7, 6, 4, 2, 1]) is true
  is-safe([list: 1, 2, 7, 8, 9]) is false
  is-safe([list: 9, 7, 6, 2, 1]) is false
  is-safe([list: 1, 3, 2, 4, 5]) is false
  is-safe([list: 8, 6, 4, 4, 1]) is false
  is-safe([list: 1, 3, 6, 7, 9]) is true
  is-safe([list: 91, 91, 93, 93, 95, 96, 99]) is false
end


fun is-sorted(l :: List<Number>) -> Boolean:
  doc: "determines if all element are sorted either in ascending or descending order"

  fun all-increasing(lst, prev):

    cases (List) lst:
      | empty => true
      | link(f, r) => 
        if f > prev:
          all-increasing(r, f)
        else:
          false
        end
    end
  end

  fun all-decreasing(lst, prev):
    cases (List) lst:
      | empty => true
      | link(f, r) => 
        if f < prev:
          all-decreasing(r, f)
        else:
          false
        end
    end
  end

  all-increasing(l.rest, l.first) or  all-decreasing(l.rest, l.first)
end