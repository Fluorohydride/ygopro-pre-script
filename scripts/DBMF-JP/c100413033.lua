--永の王 オルムガンド

--Scripted by nekrozar
function c100413033.initial_effect(c)
	c:SetUniqueOnField(1,0,100413033)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,2,nil,nil,99)
	c:EnableReviveLimit()
	--base atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c100413033.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100413033,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,100413033)
	e3:SetCost(c100413033.drcost)
	e3:SetTarget(c100413033.drtg)
	e3:SetOperation(c100413033.drop)
	c:RegisterEffect(e3)
end
function c100413033.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function c100413033.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c100413033.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c100413033.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_ONFIELD,aux.ExceptThisCard(e))
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then
		local rg1=g:Filter(Card.IsControler,nil,tp)
		g:Sub(rg1)
	end
	if Duel.Draw(1-tp,1,REASON_EFFECT)==0 then
		local rg2=g:Filter(Card.IsControler,nil,1-tp)
		g:Sub(rg2)
	end
	if g:GetCount()>0 and c:IsRelateToEffect(e) then
		local sg=Group.CreateGroup()
		local rg1=g:Filter(Card.IsControler,nil,tp)
		if rg1:GetCount()>0 then
			local sg1=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,aux.ExceptThisCard(e))
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local tc1=sg1:Select(tp,1,1,nil):GetFirst()
			sg:AddCard(tc1)
		end
		local rg2=g:Filter(Card.IsControler,nil,1-tp)
		if rg2:GetCount()>0 then
			local sg2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_HAND+LOCATION_ONFIELD,aux.ExceptThisCard(e))
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_XMATERIAL)
			local tc2=sg2:Select(1-tp,1,1,nil):GetFirst()
			sg:AddCard(tc2)
		end
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Overlay(c,sg)
		end
	end
end
