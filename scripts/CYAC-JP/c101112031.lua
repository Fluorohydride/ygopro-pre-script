--ワナビー！
--coded by Lyris
local s,id,o=GetID()
function s.initial_effect(c)
	--sset
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function s.xfilter(c)
	return c:GetSequence()<5
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4-Duel.GetMatchingGroupCount(s.xfilter,tp,0,LOCATION_SZONE,nil) end
end
function s.filter(c)
	return c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=5-Duel.GetMatchingGroupCount(s.xfilter,tp,0,LOCATION_SZONE,nil)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	if #g>0 and g:FilterCount(s.filter,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:FilterSelect(tp,s.spfilter,1,1,nil)
		Duel.SSet(tp,sg:GetFirst())
		g:Sub(sg)
	end
	if #g>0 then
		Duel.SortDecktop(tp,tp,#g)
		for i=1,#g do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
end
