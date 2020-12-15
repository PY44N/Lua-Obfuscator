local methods = {
	ArgCall = {},
	AssignmentStat = {},
	BinopExpr = {},
	BooleanLiteral = {},
	BreakStat = {},
	CallExpr = {},
	CallExprStat = {},
	DoStat = {},
	FieldExpr = {},
	FunctionLiteral = {},
	FunctionStat = {},
	GenericForStat = {},
	IfStat = {},
	IndexExpr = {},
	LocalFunctionStat = {},
	LocalVarStat = {},
	MethodExpr = {},
	NilLiteral = {},
	node = {},
	NumberLiteral = {},
	NumericForStat = {},
	ParenExpr = {},
	RepeatStat = {},
	ReturnStat = {},
	StatList = {},
	StringCall = {},
	StringLiteral = {},
	TableCall = {},
	TableLiteral = {},
	UnopExpr = {},
	VargLiteral = {},
	VariableExpr = {},
	WhileStat = {},
	-- Variable scoping
	Scoping = {}
}

local assign

do
	local cache = {}

	local function getter(what)
		local func = cache[what]

		if not func then
			func = function(self)
				return self[what]
			end
			cache[what] = func
		end

		return func
	end

	function assign(t, first, last)
		t.GetFirstToken = getter(first)
		t.GetLastToken = getter(last)
	end
end

-- Scope methods
function methods.Scoping:Rename(newName)
	self.Name = newName
	for _, renameFunc in pairs(self.RenameList) do
		renameFunc(newName)
	end
end

function methods.Scoping:Reference()
	self.UseCount = self.UseCount + 1
end

-- Node methods
assign(methods.ArgCall, 'Token_OpenParen', 'Token_CloseParen')
assign(methods.BooleanLiteral, 'Token', 'Token')
assign(methods.BreakStat, 'Token_Break', 'Token_Break')
assign(methods.DoStat, 'Token_Do', 'Token_End')
assign(methods.FunctionLiteral, 'Token_Function', 'Token_End')
assign(methods.FunctionStat, 'Token_Function', 'Token_End')
assign(methods.GenericForStat, 'Token_For', 'Token_End')
assign(methods.IfStat, 'Token_If', 'Token_End')
assign(methods.NilLiteral, 'Token', 'Token')
assign(methods.NumberLiteral, 'Token', 'Token')
assign(methods.NumericForStat, 'Token_For', 'Token_End')
assign(methods.ParenExpr, 'Token_OpenParen', 'Token_CloseParen')
assign(methods.StringCall, 'Token', 'Token')
assign(methods.StringLiteral, 'Token', 'Token')
assign(methods.TableLiteral, 'Token_OpenBrace', 'Token_CloseBrace')
assign(methods.VargLiteral, 'Token', 'Token')
assign(methods.VariableExpr, 'Token', 'Token')
assign(methods.WhileStat, 'Token_While', 'Token_End')

function methods.node:GetFirstToken()
	return assert(self:VirtualGetFirstToken(), 'no first token')
end

function methods.node:GetLastToken()
	return assert(self:VirtualGetLastToken(), 'no last token')
end

function methods.TableCall:GetFirstToken()
	return self.TableExpr:GetFirstToken()
end

function methods.TableCall:GetLastToken()
	return self.TableExpr:GetLastToken()
end

function methods.CallExpr:GetFirstToken()
	return self.Base:GetFirstToken()
end

function methods.CallExpr:GetLastToken()
	return self.FunctionArguments:GetLastToken()
end

function methods.FieldExpr:GetFirstToken()
	return self.Base:GetFirstToken()
end

function methods.FieldExpr:GetLastToken()
	return self.Field
end

function methods.MethodExpr:GetFirstToken()
	return self.Base:GetFirstToken()
end

function methods.MethodExpr:GetLastToken()
	return self.FunctionArguments:GetLastToken()
end

function methods.IndexExpr:GetFirstToken()
	return self.Base:GetFirstToken()
end

function methods.IndexExpr:GetLastToken()
	return self.Token_CloseBracket
end

function methods.UnopExpr:GetFirstToken()
	return self.Token_Op
end

function methods.UnopExpr:GetLastToken()
	return self.Rhs:GetLastToken()
end

function methods.BinopExpr:GetFirstToken()
	return self.Lhs:GetFirstToken()
end

function methods.BinopExpr:GetLastToken()
	return self.Rhs:GetLastToken()
end

function methods.CallExprStat:GetFirstToken()
	return self.Expression:GetFirstToken()
end

function methods.CallExprStat:GetLastToken()
	return self.Expression:GetLastToken()
end

function methods.AssignmentStat:GetFirstToken()
	return self.Lhs[1]:GetFirstToken()
end

function methods.AssignmentStat:GetLastToken()
	return self.Rhs[#self.Rhs]:GetLastToken()
end

function methods.RepeatStat:GetFirstToken()
	return self.Token_Repeat
end

function methods.RepeatStat:GetLastToken()
	return self.Condition:GetLastToken()
end

function methods.LocalFunctionStat:GetFirstToken()
	return self.Token_Local
end

function methods.LocalFunctionStat:GetLastToken()
	return self.FunctionStat:GetLastToken()
end

function methods.LocalVarStat:GetFirstToken()
	return self.Token_Local
end

function methods.LocalVarStat:GetLastToken()
	if #self.ExprList > 0 then
		return self.ExprList[#self.ExprList]:GetLastToken()
	else
		return self.VarList[#self.VarList]
	end
end

function methods.ReturnStat:GetFirstToken()
	return self.Token_Return
end

function methods.ReturnStat:GetLastToken()
	if #self.ExprList > 0 then
		return self.ExprList[#self.ExprList]:GetLastToken()
	else
		return self.Token_Return
	end
end

function methods.StatList:GetFirstToken()
	if #self.StatementList == 0 then
		return nil
	else
		return self.StatementList[1]:GetFirstToken()
	end
end

function methods.StatList:GetLastToken()
	if #self.StatementList == 0 then
		return nil
	elseif self.SemicolonList[#self.StatementList] then
		-- Last token may be one of the semicolon separators
		return self.SemicolonList[#self.StatementList]
	else
		return self.StatementList[#self.StatementList]:GetLastToken()
	end
end

return methods
