#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Imports
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

using Main.JuliaSub: parseJuliaCode, parseJuliaFile

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Aux values and functions
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

const QUOTE = :quote
const BLOCK = :block

const EMPTY_BLOCK = Expr(BLOCK)

# Wraps `expr` in quote expression
wrapQuote(expr) = Expr(QUOTE, expr)
# Wraps `expr` in block expression
wrapBlock(expr) = Expr(BLOCK, expr)

# Checks that after stripping line numbers,
# `testee` is equal to quoted `reference`
parseTest(testee, reference) =
    MacroTools.striplines(testee) == wrapQuote(reference)

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Tests
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

@testset "utils :: parsing Julia" begin
    @test parseTest(parseJuliaCode(""), EMPTY_BLOCK)
    @test parseTest(parseJuliaFile(testFilePath("empty.jl")), EMPTY_BLOCK)

    @test parseTest(parseJuliaCode("5"), wrapBlock(5))
    @test parseTest(parseJuliaFile(testFilePath("const10.jl")),
            wrapBlock(:(const N = 10)))
end

#--------------------------------------------------

@testset "utils :: multiset" begin
    @test mergewith!(Multiset(1,2,2,3), Multiset(5,1)) ==
            Multiset(1,1,2,2,3,5)
    @test mergewith!(Multiset(), Multiset(5,1,3)) ==
            Multiset(1,3,5)
end
