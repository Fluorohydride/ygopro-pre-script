--花札衛－牡丹に蝶－
--Cardian - Botan ni Cho
--Script by dest
function c100910014.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCondition(c100910014.hspcon)
	e1:SetOperation(c100910014.hspop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100910014,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c100910014.target)
	e2:SetOperation(c100910014.operation)
	c:RegisterEffect(e2)
end
function c100910014.hspfilter(c)
	return c:IsSetCard(0xe6) and not c:IsCode(100910014)
end
function c100910014.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(c:GetControler(),c100910014.hspfilter,1,nil)
end
function c100910014.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),c100910014.hspfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c100910014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c100910014.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0xe6) then
			local ct=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
			if ct<3 then return end
			local g=Duel.GetDecktopGroup(1-tp,3)
			Duel.ConfirmCards(tp,g)
			local opt=Duel.SelectOption(tp,aux.Stringid(100910014,1),aux.Stringid(100910014,2))
			Duel.SortDecktop(tp,1-tp,3)
			if opt==1 then
				for i=1,3 do
					local mg=Duel.GetDecktopGroup(tp,1)
					Duel.MoveSequence(mg:GetFirst(),1)
				end
			end
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
		Duel.ShuffleHand(tp)
	end
end
