--サプライズ・チェーン
--
--script by Raye Hikawa
function c101108068.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101108068+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101108068.condition)
	e1:SetTarget(c101108068.target)
	e1:SetOperation(c101108068.activate)
	c:RegisterEffect(e1)
end
function c101108068.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>=2
end
function c101108068.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local cl=Duel.GetCurrentChain()
	if chk==0 then return cl>=2 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=cl
		or cl>=3 and Duel.IsPlayerCanDiscardDeck(tp,1)
		or cl>=4 and Duel.IsPlayerCanDraw(tp,1)
	end
	if cl>=3 then Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK) end
	if cl>=4 then Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) end
end
function c101108068.activate(e,tp,eg,ep,ev,re,r,rp)
	local cl=Duel.GetCurrentChain()
	if cl>=2 then Duel.SortDecktop(tp,tp,cl) end
	if cl>=3 then Duel.SendtoGrave(Duel.GetDecktopGroup(tp,1),REASON_EFFECT) end
	if cl>=4 then Duel.Draw(tp,1,REASON_EFFECT) end
end
