use context starter2024

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